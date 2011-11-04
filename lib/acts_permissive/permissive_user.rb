module ActsPermissive
  module PermissiveUser

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_permissive
        has_many :memberships
        has_many :groups, :through => :memberships
        include ActsPermissive::PermissiveUser::InstanceMethods
        extend ActsPermissive::UserScopes
      end
    end

    module InstanceMethods

      def is_permissive?
        "Yes"
      end
    end
  end
end