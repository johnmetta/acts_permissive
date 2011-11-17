module ActsPermissive
  module PermissiveUser

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_permissive
        has_many  :circlings, :as => :ownable, :class_name => "ActsPermissive::Circling"
        has_many  :circles, :through => :circlings, :class_name => 'ActsPermissive::Circle'
        has_many :groupings, :as => :permissible, :class_name => "ActsPermissive::Grouping"
        has_many :permissions, :through => :groupings, :class_name => "ActsPermissive::Permission"
        include ActsPermissive::PermissiveUser::InstanceMethods

      end
    end

    module InstanceMethods

      def is_permissive?
        true
      end

      def build_circle params = {}
        params[:name] = "Unnamed Circle" if params[:name].nil?
        params[:mask] = 255 if params[:mask].nil?
        params[:objects] = [] if params[:objects].nil?

        circle = self.circles.build(:name => params[:name])
        perm = permissions.build(:circle => circle, :mask => params[:mask])
        save!
        params[:objects].each do |o|
          o.circles << circle if o.is_used_permissively?
        end
        if !circle.save
          raise ActsPermissive::PermissiveError, circle.errors
        end
        circle
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