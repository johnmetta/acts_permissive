module ActsPermissive
  module PermissiveUser

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_permissive
        has_many  :circlings, :as => :usable, :class_name => "ActsPermissive::Circling"
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
        #Set up the option defaults
        params[:name] = "Unnamed Circle" if params[:name].nil?
        params[:mask] = 255 if params[:mask].nil?
        params[:objects] = [] if params[:objects].nil?

        #Build the circle and set the permissions mask
        circle = circles.build(:name => params[:name])
        permissions.build(:circle => circle, :mask => params[:mask])
        save!

        #If there are any objects in the list that don't respond to is_used_permissively, they
        # are silently ignored
        params[:objects].select{|o| o.respond_to? :is_used_permissively?}.each{ |o| o.add_to circle}

        #return for use
        circle
      end

      def can! *args
        options = args.extract_options!
        options.assert_valid_keys(:on, :reset)
        if options[:on]
          permission = Permission.for(self).on(options[:on])
          permission = permissions.build(:circle => options[:on]) if permission.nil?
          puts permission.to_yaml
          raise PermissiveError, "Uh oh, ambiguous permission mapping" if permission.class != Permission
        end
        permission
      end

    end
  end
end