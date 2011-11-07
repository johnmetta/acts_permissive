module ActsPermissive
  module PermissiveObject

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def is_used_permissively
        has_one :circle, :as => :circleable, :class_name => "ActsPermissive::Circle"
        include ActsPermissive::PermissiveObject::InstanceMethods
        validates_presence_of :guid
        before_validation :build_guid_and_circle
      end
    end

    module InstanceMethods

      # Returns true if this instance is following the object passed as an argument.
      def is_used_permissively?
        true
      end

      def is_public?
        circle.is_public
      end

      def circle_of_trust
        circle
      end

      #############################################################

      def make_private!
        is_public = false
        self.save!
      end

      def make_public!
        is_public = true
        self.save!
      end

      private

      # Creates a default object
      def build_guid_and_circle
        self.guid = UUIDTools::UUID.random_create.to_str if self.guid.nil?
        self.circle = Circle.create(:name => self.guid, :is_hidden => true, :is_public => false)
        raise self.circle.errors if not self.circle.save
      end

    end

  end
end