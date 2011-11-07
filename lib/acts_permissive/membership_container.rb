module ActsPermissive
  class MembershipContainer
    include ActiveModel::Validations
    attr_accessor :role, :circle, :user, :grant, :calling_user

    validates_presence_of :role, :circle, :user, :grant, :calling_user

    #############
    # Set roles
    def read
      self.role = Role.read
      validate_or_return
    end
    def write
      self.role = Role.write
      validate_or_return
    end
    def admin
      self.role = Role.admin
      validate_or_return
    end
    alias :administration :admin
    def owner
      self.role = Role.owner
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
      raise "Must send circle instance" if circle.class != Circle
      self.circle = circle
      validate_or_return
    end

    private

    def get_circle_for obj
      if obj.class == Circle
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
      if grant
        Membership.create(:user => user, :role => role, :circle => circle).save!
      else
        Membership.where("user_id == #{user.id}")
                                  .where("circle_id == #{default_circle.id}")
                                  .where("role_id == #{Role.owner.id}")
                                  .each do |m|
          m.destroy!
        end
      end
    end

    #########
    #
    def validate_or_return
      test_privileges
      if self.valid?
        build_membership!
      else
        self
      end
    end

    def test_privileges
      if role
        if [Role.owner, Role.admin].include? role
          raise PermissiveException("User must own resource to add owners/admins") if not calling_user.owns?(circle)
          end
        raise PermissiveException("User must be an admin to add read/write privileges") if not calling_user.admins?(circle)
      end
    end

  end

end