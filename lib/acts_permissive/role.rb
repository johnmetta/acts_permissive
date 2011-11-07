module ActsPermissive
  class Role < ActiveRecord::Base
    has_many :memberships

    #Make power unique, but allow for user extension by scoping on name
    validates_uniqueness_of :power, :scope => :name

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