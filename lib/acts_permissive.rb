#require 'simplecov'
#SimpleCov.start 'rails'

require 'uuidtools'
require 'acts_permissive/version'
require 'acts_permissive/membership'
require 'acts_permissive/membership_container'
require 'acts_permissive/circle'
require 'acts_permissive/role'
require 'acts_permissive/exceptions'

module ActsPermissive
  autoload :PermissiveObject,   'acts_permissive/permissive_object'
  autoload :PermissiveUser,     'acts_permissive/permissive_user'
  autoload :UserScopes,         'acts_permissive/user_scopes'

  require 'acts_permissive/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
end

ActiveRecord::Base.send :include, ActsPermissive::PermissiveUser
ActiveRecord::Base.send :include, ActsPermissive::PermissiveObject