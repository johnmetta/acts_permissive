module ActsPermissive
  module PermissiveObject

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def is_used_permissively
        has_many  :circlings, :as => :circleable, :class_name => "ActsPermissive::Circling"
        has_many  :circles, :through => :circlings, :class_name => "ActsPermissive::Circle"
        include   ActsPermissive::PermissiveObject::InstanceMethods
      end

    end

    module InstanceMethods

      def is_used_permissively?
        true
      end

      def add_to circle
        self.circles << circle
        save!
      end
      def remove_from circle
        self.circles.delete circle
        save!
      end

    end
  end
end