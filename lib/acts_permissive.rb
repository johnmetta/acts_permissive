#require 'simplecov'
#SimpleCov.start 'rails'

require 'uuidtools'
require 'acts_permissive/version'
require 'acts_permissive/exceptions'
require 'acts_permissive/permission_map'
require 'acts_permissive/circle'
require 'acts_permissive/circling'
require 'acts_permissive/grouping'
require 'acts_permissive/permission'

module ActsPermissive
  autoload :PermissiveUser,   'acts_permissive/permissive_user'
  autoload :PermissiveObject, 'acts_permissive/permissive_object'

  require 'acts_permissive/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
end

ActiveRecord::Base.send :include, ActsPermissive::PermissiveUser
ActiveRecord::Base.send :include, ActsPermissive::PermissiveObject
ActiveResource::Base.send :include, ActsPermissive::PermissiveObject
