module ActsPermissive
  class Role < ActiveRecord::Base
    has_many :memberships

    validates_uniqueness_of :power, :name

    def self.owner
      Role.find_by_power("1000")
    end
    def self.admin
      Role.find_by_power("0100")
    end
    def self.write
      Role.find_by_power("0010")
    end
    def self.read
      Role.find_by_power("0001")
    end

    def binary
      self.power.to_i(2)
    end

  end
end