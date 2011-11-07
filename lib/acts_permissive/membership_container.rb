module ActsPermissive
  class MembershipContainer
    include ActiveModel::Validations
    attr_accessor :role, :circle, :user, :grant, :calling_user

    validates_presence_of :role, :circle, :user, :grant, :calling_user

    #############
    # Set roles
    def read
      role = ActsPermissive::Role.read
      validate_or_return
    end
    def write
      role = ActsPermissive::Role.write
      validate_or_return
    end
    def admin
      role = ActsPermissive::Role.admin
      validate_or_return
    end
    alias :administration :admin
    def owner
      role = ActsPermissive::Role.owner
      validate_or_return
    end
    alias :ownership :owner

    ##############
    # Set User
    def to user
      raise "Must send user instance" if user.class != User
      self.user = user
      validate_or_return
    end
    alias :from :to

    ##########
    # Set Circle
    def on obj
      circle = get_circle_for obj
      raise "Must send circle instance" if circle.class != ActsPermissive::Circle
      self.circle = circle
      validate_or_return
    end

    private

    def get_circle_for obj
      if obj.class == ActsPermissive::Circle
        obj
      elsif obj.is_used_permissively?
        obj.circle
      else
        raise "Argument must be a trust circle or an object that is used permissively"
      end
    end

    #############
    # Create a membership
    def build_membership!
      test_privileges
      if grant
        ActsPermissive::Membership.create(:user => user, :role => role, :circle => circle).save!
      else
        ActsPermissive::Membership.where("user_id == #{user.id}")
                                  .where("circle_id == #{default_circle.id}")
                                  .where("role_id == #{ActsPermissive::Role.owner.id}")
                                  .each do |m|
          m.destroy!
        end
      end
    end

    #########
    #
    def validate_or_return
      if self.valid?
        build_membership!
      else
        self
      end
    end

    def test_privileges
      if [ActsPermissive::Role.owner, ActsPermissive::Role.admin].include? role
        raise "User must own resource to add owners/admins" if not calling_user.owns?(circle)
        end
      raise "User must be an admin to add read/write privileges" if not calling_user.admins?(circle)
    end

  end

end