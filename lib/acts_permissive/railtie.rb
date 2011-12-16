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

    initializer "acts_permissive.active_resource" do |app|
      ActiveSupport.on_load :active_record do
        include ActsPermissive::PermissiveUser
        include ActsPermissive::PermissiveObject
      end
    end

  end
end
