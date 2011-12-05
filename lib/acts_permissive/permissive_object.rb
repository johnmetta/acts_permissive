module ActsPermissive
  module PermissiveObject

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def is_used_permissively
        has_many  :circlings, :as => :circleable, :class_name => "ActsPermissive::Circling"
        has_many  :circles, :through => :circlings, :class_name => "ActsPermissive::Circle"
        include   ActsPermissive::PermissiveObject::InstanceMethods
      end

    end

    module InstanceMethods

      def is_used_permissively?
        true
      end

      def add_to circle
        self.circles << circle
        save!
      end
      def remove_from circle
        self.circles.delete circle
        save!
      end

      #TODO: Refactor this shit!
      def all_who_can *args
        # Get a list of users who can do whatever symbol based permissions are
        # listed. For instance
        # authors = @thing.all_who_can(:read, :write)
        all_users = []
        circles.each do |c|
          c.users.each do |u|
            all_users << u
          end
        end
        all_users.uniq!

        users = []

        # Go through each user, go though each permission that user has for this object
        # (i.e. in all the objects circles), and if there's a permission that matches,
        # add the user to the list of users.
        all_users.each do |user|
          user.permissions_for(self).each do |perm|
            if args.include?(:see)
              raise PermissiveError, "Can only use :see as an option by itself" if args.count > 1
              # We're already here, so permissions is not nil, so just add the user
              # if permissions_for returns a blank list, the user can't "see" this object,
              # but we'd never get here because the .each loop would just not happen
              users << user
            else
              #add up the bits and do a bitwise and to check permissions
              bits = args.select{|o| o.class == Symbol}.map{|s| Permission.bit_for s}.inject(0){|sum, p| sum + p}
              users << user if perm.mask & bits == bits
            end
          end
        end

        # we lazily add users in a loop, instead of using SQL, so we have to return only the unique set
        users.uniq
      end
    end
  end
end