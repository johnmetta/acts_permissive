module ActsPermissive
  module PermissiveObject

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def is_used_permissively
#        has_many :circles, :through => :circleable
        include ActsPermissive::PermissiveObject::InstanceMethods
#        include ActsAsFollower::FollowerLib
      end
    end

    module InstanceMethods

      # Returns true if this instance is following the object passed as an argument.
      def is_used_permissively?
        "Yes"
      end
    end

  end
end