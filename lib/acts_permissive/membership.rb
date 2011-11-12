module ActsPermissive
  class Membership < ActiveRecord::Base
    belongs_to :circle
    belongs_to :user

    attr_accessor :power

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

    def self.to_bin value
      if value.class == String
        value.to_i(2)
      elsif value.class == Integer
        value.to_s(2).rjust(9)
      end
    end

    def self.owner
      to_bin 256
    end

    def self.admin
      to_bin 128
    end

    def self.read
      to_bin 64
    end

    def self.write
      to_bin 32
    end


  end
end