class Membership < ActiveRecord::Base
  extend ActsPermissive::PermissiveLib

  belongs_to :circle
  belongs_to :user

  validates_uniqueness_of :circle_id, :scope => [:user_id, :power]

  scope :by_user, lambda { |user|
    where('user_id = ?', user.id)
  }
  scope :by_circle, lambda { |circle|
    where('circle_id = ?', circle.id)
  }
  scope :by_power, lambda { |power|
    where('power = ?', power)
  }

end
