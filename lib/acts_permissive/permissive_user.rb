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
        include ActsPermissive::PermissiveLib
        validates_presence_of :guid
        before_validation :create_guid!
      end

    end

    module InstanceMethods

      def is_permissive?
        true
      end

      def create_as_owner klass, params = {}
        if klass.respond_to? :is_used_permissively
          obj = klass.create params
          membership = Membership.create :user_id => id,
                                         :power => binary_owner,
                                         :circle_id => obj.circle.id
          membership.save!
          obj
        end
      end

      def make_owner_of obj
        if not obj.is_used_permissively?
          raise "Must be called with an object that is_used_permissively"
        end
        membership = Membership.create :user_id => id,
                                       :power => owner_bin_string,
                                       :circle_id => obj.circle.id
        membership.save!
      end

      # Permission granting
      def grant
        mc = MembershipContainer.new
        mc.grant = true
        mc.calling_user = self
        mc
      end
      alias :grants :grant

      def revoke
        mc = MembershipContainer.new
        mc.grant = false
        mc.calling_user = self
        mc
      end
      alias :revokes :revoke

      def is_member_of? obj
        circle = get_circle_for obj
        Membership.by_user(self).by_circle(circle) != nil
      end

      def powers_in obj
        circle = get_circle_for obj
        membership = Membership.by_user(self).by_circle(circle).first
        if membership
          membership.power.to_i(2)
        else
          0
        end
      end

      def owns? obj
        circle = get_circle_for obj
        powers_in(circle) & 128 == 128
      end

      def can_admin? obj
        circle = get_circle_for obj
        powers_in(circle) & 64 == 64
      end
      def can_write? obj
        circle = get_circle_for obj
        powers_in(circle) & 32 == 32
      end
      def can_read? obj
        circle = get_circle_for obj
        powers_in(circle) & 16 == 16
      end

      def can_see? obj
        can_read?(obj) || can_write?(obj) || can_admin?(obj) || owns?(obj)
      end

    end
  end
end