module ActsPermissive
  class Membership < ActiveRecord::Base
    belongs_to :circle
    belongs_to :user
    belongs_to :role

    scope :by_user, lambda { |user|
      where('user_id = ?', user.id)
    }
    scope :by_circle, lambda { |circle|
      where('circle_id = ?', circle.id)
    }
    scope :by_role, lambda { |role|
      where('role_id = ?', role.id)
    }
  end
end