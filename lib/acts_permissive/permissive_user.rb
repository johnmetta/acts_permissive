module ActsPermissive
  module PermissiveUser

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_permissive
#        has_many :memberships
        include ActsPermissive::PermissiveUser::InstanceMethods
#        include ActsAsFollower::FollowerLib
      end
    end

    module InstanceMethods

      # Returns true if this instance is following the object passed as an argument.
      def is_permissive?
        "Yes"
      end
    end
  end
end