require 'acts_permissive/version'

module ActsPermissive
  autoload :PermissiveObject,   'acts_permissive/permissive_object'
  autoload :PermissiveUser,     'acts_permissive/permissive_user'
  autoload :UserScopes,         'acts_permissive/user_scopes'

  require 'acts_permissive/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
end

ActiveRecord::Base.send :include, ActsPermissive::PermissiveUser