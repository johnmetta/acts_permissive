module ActsPermissive
  class Role < ActiveRecord::Base
    has_many :memberships

    validates_uniqueness_of :name, :power

    def self.owner
      Role.find_by_name("owner")
    end
    def self.admin
      Role.find_by_name("admin")
    end
    def self.read
      Role.find_by_name("read")
    end
    def self.write
      Role.find_by_name("write")
    end

    def binary
      self.power.to_i(2)
    end

  end
end