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

      def is_permissive?
        true
      end

      def make_owner_of obj
        if not obj.is_used_permissively?
          raise "Must be called with an object that is_used_permissively"
        end
        membership = ActsPermissive::Membership.create :user => self, :role => ActsPermissive::Role.owner, :circle => obj.circle
        membership.save
      end

      # Permission granting
      def grant; ActsPermissive::MembershipContainer.new :grant => true, :calling_user => self end
      alias :grants :grant

      def revoke; ActsPermissive::MembershipContainer.new :grant => false, :calling_user => self end
      alias :revokes :revoke

      def is_member_of? obj
        circle = get_circle_for obj
        ActsPermissive::Membership.by_user(self).by_circle(circle) != nil
      end

      def roles_in obj
        circle = get_circle_for obj
        roles = []
        ActsPermissive::Membership.by_user(self).by_circle(circle).each do |membership|
          roles << membership.role
        end
        roles
      end

      def roleset_in obj
        circle = get_circle_for obj
        self.roles_in(circle).inject(0) { |result, role| result | role.binary}
      end

      def owns? obj
        circle = get_circle_for obj
        roleset_in(circle) & 8 == 8
      end
      def admins? obj
        circle = get_circle_for obj
        roleset_in(circle) & 4 == 4
      end
      def writes? obj
        circle = get_circle_for obj
        roleset_in(circle) & 2 == 2
      end
      def reads? obj
        circle = get_circle_for obj
        circle.is_public || (roleset_in(circle) & 1 == 1)
      end

      private

      def create_guid
        self.guid = UUIDTools::UUID.random_create.to_str if self.guid.nil?
      end

      def get_circle_for obj
        if obj.class == ActsPermissive::Circle
          obj
        elsif obj.is_used_permissively?
          obj.circle
        else
          raise "Argument must be a trust circle or an object that is used permissively"
        end
      end
    end
  end
end