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

      def make_owner_of obj
        if not obj.is_used_permissively?
          raise "Must be called with an object that is_used_permissively"
        end
        membership = Membership.create :user_id => id,
                                       :power => binary_owner,
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
        powers = []
        Membership.by_user(self).by_circle(circle).each do |membership|
          # Need to re
          powers << membership.power
        end
        powers
      end

      def power_set_in obj
        circle = get_circle_for obj
        self.powers_in(circle).inject(0) { |result, power| result | as_integer(power)}
      end

      def owns? obj
        circle = get_circle_for obj
        power_set_in(circle) & 256 == 256
      end

      def can_admin? obj
        admins?(obj) || owns?(obj)
      end
      def can_write? obj
        writes?(obj) || owns?(obj)
      end
      def can_read? obj
        circle = get_circle_for obj
        circle.is_public || reads?(obj) || owns?(obj)
      end

      def admins? obj
        circle = get_circle_for obj
        power_set_in(circle) & 128 == 128
      end
      def writes? obj
        circle = get_circle_for obj
        power_set_in(circle) & 64 == 64
      end
      def reads? obj
        circle = get_circle_for obj
        power_set_in(circle) & 32 == 32
      end

    end
  end
end