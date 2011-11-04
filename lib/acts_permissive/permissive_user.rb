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
        validates_presence_of :guid
        before_validation :create_guid
      end
    end

    module InstanceMethods

      def create_guid
        self.guid = UUIDTools::UUID.random_create.to_str if self.guid.nil?
      end

      def grants
        MembershipContainer.new
      end
      alias :grant :grants

      def is_role_in_circle? role, circle
        Membership.by_user(self).by_role(role).by_circle(circle) != nil
      end

      def is_member_of? circle
        Membership.by_user(self).by_circle(circle) != nil
      end

      def roles_in circle
        roles = []
        Membership.by_user(self).by_circle(circle).each do |membership|
          roles << membership.role
        end
        roles
      end

      def roleset_in circle
        self.roles_in(circle).inject(0) { |result, role| result | role.binary}
      end

      def can_read? circle
        self.roleset_in circle && 1
      end

    end
  end
end