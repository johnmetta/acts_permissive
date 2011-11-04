module ActsPermissive
  class MembershipContainer
    include ActiveModel::Validations
    attr_accessor :role, :circle, :user

    validates_presence_of :role, :circle, :user

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
    def owner
      role = ActsPermissive::Role.owner
      validate_or_return
    end

    ##############
    # Set User
    def to user
      raise "Must send user instance" if user.class != User
      user = user
      validate_or_return
    end

    ##########
    # Set Circle
    def on circle
      raise "Must send circle instance" if circle.class != ActsPermissive::Circle
      circle = circle
      validate_or_return
    end

    #############
    # Create a membership
    def build_membership!
      ActsPermissive::Membership.create(:user => user, :role => role, :circle => circle).save!
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

  end

end