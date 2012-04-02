module ActsPermissive
  module PermissiveObject

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def is_used_permissively *args
        options = args.extract_options!
        options.assert_valid_keys(:active_resource)

        include   ActsPermissive::PermissiveObject::InstanceMethods

        if options[:active_resource]
          include ActsPermissive::PermissiveObject::ActiveResourceSafeMethods
        else
          has_many  :circlings, :as => :circleable, :class_name => "ActsPermissive::Circling", :dependent => :destroy
          has_many  :circles, :through => :circlings, :class_name => "ActsPermissive::Circle"
          send :include, ActsPermissive::PermissiveObject::ActiveRecordSafeMethods
        end
      end

    end

    module InstanceMethods

      def is_used_permissively?
        true
      end

      #TODO: Refactor this shit!
      def all_who_can *args
        # Get a list of users who can do whatever symbol based permissions are
        # listed. For instance
        # authors = @thing.all_who_can(:read, :write)
        warn "\nPermissiveObject::all_who_can works, yeah, but it's a time suck. Use Carefully!"
        if args.include?(:see)
          raise PermissiveError, "Can only use :see as an option by itself" if args.count > 1
          return ActsPermissive::Grouping.who_can_see(self)
        end

        users = []

        # Go through each user, go though each permission that user has for this object
        # (i.e. in all the objects circles), and if there's a permission that matches,
        # add the user to the list of users.
        ActsPermissive::Grouping.who_can_see(self).each do |user|
          user.permissions_for(self).each do |perm|
            #add up the bits and do a bitwise and to check permissions
            bits = args.select{|o| o.class == Symbol}.map{|s| Permission.bit_for s}.inject(0){|sum, p| sum + p}
            users << user if perm.mask & bits == bits
          end
        end

        # we lazily add users in a loop, instead of using SQL, so we have to return only the unique set
        users.uniq
      end
    end

    module ActiveRecordSafeMethods
      def add_to *args
        args.each{|c| self.circles << c}
        save!
      end

      def remove_from *args
        args.each{|c| self.circles.delete c}
        save!
      end
    end

    module ActiveResourceSafeMethods
      def circlings
        ActsPermissive::Circling.all :conditions => {:circleable_id => self.id,
                                                     :circleable_type => self.class.name}
      end

      def circles
        ActsPermissive::Circle.find circlings.map{|i| i.circle_id}
      end

      def add_to *args
        args.each do |arg|
          ActsPermissive::Circling.create! :circleable_id => self.id,
                           :circleable_type => self.class.name,
                           :circle_id => arg.id
        end
      end

      def remove_from *args
        args.each do |arg|
          raise "Must be a circle" if arg.class != Circle
          circles = ActsPermissive::Circling.first(:conditions => {
                                  :circle_id => arg.id,
                                  :circleable_id => self.id,
                                  :circleable_type => self.class.name}).destroy
        end
      end
    end

  end
end