module ActsPermissive
  module PermissiveUser

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_permissive
        has_many  :circle_owners, :as => :ownable, :class_name => "ActsPermissive::CircleOwners"
        has_many  :owned_circles, :through => :circle_owners, :source => :ownable, :class_name => 'ActsPermissive::PermissiveCircle'
        has_many :groupings, :as => :grouper
        has_many :permissions, :through => :groupings, :class_name => "PermissivePermission"
        include ActsPermissive::PermissiveUser::InstanceMethods

      end
    end

    module InstanceMethods

      def is_permissive?
        true
      end

      def build_circle name = "Unnamed Circle", objects = []
#        circle = ActsPermissive::PermissiveCircle.new( :name => name )
        circle = self.owned_circles.build(:name => name)
        objects.each do |o|
          o.circles << circle if o.is_used_permissively?
        end
        if circle.save
          circle
        else
          raise ActsPermissive::PermissiveError, circle.errors
        end
      end

      def permissive_circles
        Permission.for(self)
      end

      def circles
        owned_circles + permissive_circles
      end
    end
  end
end