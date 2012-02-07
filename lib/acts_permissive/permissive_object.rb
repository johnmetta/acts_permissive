module ActsPermissive
  module PermissiveObject

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def is_used_permissively
        has_many  :circlings, :as => :circleable, :class_name => "ActsPermissive::Circling", :dependent => :destroy
        has_many  :circles, :through => :circlings, :class_name => "ActsPermissive::Circle"
        include   ActsPermissive::PermissiveObject::InstanceMethods

      end

    end

    module InstanceMethods

      def is_used_permissively?
        true
      end

      def add_to *args
        args.each{|c| self.circles << c}
        save!
      end

      def remove_from *args
        args.each{|c| self.circles.delete c}
        save!
      end

      #TODO: Refactor this shit!
      def all_who_can *args
        # Get a list of users who can do whatever symbol based permissions are
        # listed. For instance
        # authors = @thing.all_who_can(:read, :write)

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
  end
end