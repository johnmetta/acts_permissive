module ActsPermissive
  module PermissiveObject

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def is_used_permissively
        has_many  :permissive_circlings, :as => :thing_circler
        has_many  :permissive_circles, :through => :permissive_circlings, :class_name => "PermissiveCircle"
        include   ActsPermissive::PermissiveObject::InstanceMethods
      end

    end

    module InstanceMethods

      def is_used_permissively?
        true
      end

      def circles
        permissive_circles
      end
    end
  end
end