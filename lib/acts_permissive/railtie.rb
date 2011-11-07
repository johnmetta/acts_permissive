require 'acts_permissive'
require 'rails'

module ActsPermissive
  class Railtie < Rails::Railtie

    initializer "acts_permissive.active_record" do |app|
      ActiveSupport.on_load :active_record do
        include ActsPermissive::PermissiveUser
        include ActsPermissive::PermissiveObject
      end
    end

    initializer "Seed database with roles" do |app|
      Role.create!(:name => "owner", :power => '1000')
      Role.create!(:name => "admin", :power => '0100')
      Role.create!(:name => "write", :power => '0010')
      Role.create!(:name => "read",  :power => '0001')
    end

  end
end
