require 'acts_permissive/version'
require 'acts_permissive/permissive_circle'

module ActsPermissive
  autoload :PermissiveCircle,    'acts_permissive/permissive_circle'
  autoload :PermissiveUser,     'acts_permissive/permissive_user'
end

ActiveRecord::Base.send :include, ActsPermissive::PermissiveUser