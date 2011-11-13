module ActsPermissive
  class MembershipContainer
    include ActiveModel::Validations
    attr_accessor :power, :circle, :user, :grant, :calling_user

    validates_presence_of :power, :circle, :user, :grant, :calling_user

    ##############
    # TODO: Figure out how to load PermissiveLib from this non-ActiveResource class and remove these helpers
    def to_bin value
      if value.class == String
        value.to_i(2)
      elsif value.class == Integer
        value.to_s(2).rjust(9,'0')
      end
    end

    def owner
      to_bin 256
    end

    def admin
      to_bin 128
    end

    def write
      to_bin 64
    end

    def read
      to_bin 32
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
                                  .where("circle_id == #{default_circle.id}")
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
    end

  end

end