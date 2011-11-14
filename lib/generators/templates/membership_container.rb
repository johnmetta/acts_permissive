class MembershipContainer
  include ActiveModel::Validations
  include ActsPermissive::PermissiveLib

  attr_accessor :power, :circle, :user, :grant, :calling_user

  validates_presence_of :power, :circle, :user, :grant, :calling_user

  def owner
    self.power = self.binary_owner
    validate_or_return
  end

  def admin
    self.power = self.binary_admin
    validate_or_return
  end

  def write
    self.power = self.binary_write
    validate_or_return
  end

  def read
    self.power = self.binary_read
    validate_or_return
  end
  ##########################

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
      Membership.create(:user => user, :power => power, :circle => circle).save!
    else
      Membership.where("user_id == #{user.id}")
                                .where("circle_id == #{circle.id}")
                                .where("power == #{power}")
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
    if circle
      if [Membership.binary_owner, Membership.binary_admin].include?(power) and not calling_user.owns?(circle)
        raise ActsPermissive::PermissiveException, "Only owners can add administrator or other owners"
      elsif not calling_user.can_admin?(circle)
        raise ActsPermissive::PermissiveException, "Only administrators and owners can change permissions"
      end
    end
  end

end
