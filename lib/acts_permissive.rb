#require 'simplecov'
#SimpleCov.start 'rails'

require 'uuidtools'
require 'acts_permissive/version'
require 'acts_permissive/exceptions'
require 'acts_permissive/permissive_lib'

module ActsPermissive
  autoload :UserScopes,         'acts_permissive/user_scopes'
  autoload :PermissiveLib,      'acts_permissive/permissive_lib'
  autoload :PermissiveObject,   'acts_permissive/permissive_object'
  autoload :PermissiveUser,     'acts_permissive/permissive_user'

  require 'acts_permissive/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
end

ActiveRecord::Base.send :include, ActsPermissive::PermissiveUser
ActiveRecord::Base.send :include, ActsPermissive::PermissiveObject
