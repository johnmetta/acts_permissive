require 'acts_permissive'
require 'rails'

module ActsPermissive
  class Railtie < Rails::Railtie

    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'railties/*.rake')].each { |f| load f }
    end

    initializer "acts_permissive.active_record" do |app|
      ActiveSupport.on_load :active_record do
        include ActsPermissive::PermissiveUser
        include ActsPermissive::PermissiveObject
      end
    end

  end
end
