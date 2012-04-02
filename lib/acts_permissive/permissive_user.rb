module ActsPermissive
  module PermissiveUser

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_permissive
        send :include, ActsPermissive::PermissiveUser::InstanceMethods

        has_many :groupings, :as => :permissible, :class_name => "ActsPermissive::Grouping", :dependent => :destroy
        has_many :permissions, :through => :groupings, :class_name => "ActsPermissive::Permission", :dependent => :destroy

      end

    end

    module InstanceMethods

      def acts_permissive?
        true
      end

      def circles *args
        params = args.extract_options!
        params.assert_valid_keys(:of_type)
        params[:of_type] = Circle if params[:of_type].nil?
        params[:of_type].by_user self
      end

      def build_circle *args
        #Set up the option defaults
        params = args.extract_options!
        params.assert_valid_keys(:name, :mask, :objects, :class)

        params[:name] = "Unnamed Circle" if params[:name].nil?
        params[:mask] = 255 if params[:mask].nil?
        params[:objects] = [] if params[:objects].nil?
        params[:class] = Circle if params[:class].nil?

        #Build the circle and set the permissions mask
        circle = params[:class].create :name => params[:name]
        permissions.build :circle => circle, :mask => params[:mask]
        save!

        #If there are any objects in the list that don't respond to is_used_permissively, they
        # are silently ignored
        params[:objects].select{|o| o.respond_to? :is_used_permissively?}.each{ |o| o.add_to circle}

        #return for use
        circle
      end

      def permissions_in circle
        raise PermissiveError, "Must be an ActsPermissive::Circle instance" if not circle.is_a?(Circle)
        Permission.for(self).in(circle).first
      end

      def permissions_for obj
        obj.circles.map{ |c| permissions_in(c) }.compact
      end

      def reset_permissions! *args
        options = args.extract_options!
        options.assert_valid_keys(:in)

        raise PermissiveError, "Must be called with a circle as an argument" if options[:in].nil?

        #get the permission, or build it if it doesn't exist
        perm = permissions_in(options[:in])
        if perm.nil?
          return
        end
        perm.reset!
      end

      def can! *args
        options = args.extract_options!
        options.assert_valid_keys(:in)

        # We're only using this if there are circles- not on generic objects, which should be INSIDE circles
        raise PermissiveError, "Must be called with a circle as an argument" if options[:in].nil?

        #get the permission, or build it if it doesn't exist
        perm = permissions_in(options[:in])
        if perm.nil?
          perm = permissions.build(:circle => options[:in])
        end

        # For each permission, bitwise OR them together unless we have a zero, in which case we just ignore
        args.select{|o| o.class == Symbol}.each do |name|
          bit = Permission.bit_for name
          perm.mask = perm.mask & bit != 0 ? 0 : perm.mask | bit
        end

        raise PermissiveError, "Cannot save permission: #{perm.errors}" if not save!
        perm
      end

      def can? *args
        #TODO this is freakin long. Refactor this shit
        options = args.extract_options!
        options.assert_valid_keys(:in, :see)

        # Get the bitmap for the selected permissions
        bits = args.select{|o| o.class == Symbol}.map{|s| Permission.bit_for s}.inject(0){|sum, p| sum + p }

        #if we're checking for :see, return right away
        if options[:see]
          return permissions_in(options[:see]).present?
        end

        # Get a list of objects that we might be searching on
        objects = args.select{|o| o.respond_to? :is_used_permissively?}

        raise "Cannot search in both circles and objects at the same time" if options[:in].present? and objects.count > 0

        if options[:in].nil? and objects.count > 0
          warn "You are testing permissions on multiple objects. This is an OR query, which will return true if ANY have the requested permission" if objects.count > 1
          objects.each do |object|
            object.circles.each do |circle|
              # return true immediately if we find a circle where our permissions cover the bitmask
              perm = permissions_in circle
              if perm.present?
                return true if perm.mask & bits == bits
              end
            end
          end
        elsif options[:in].present?
          #Get the permissions and return
          perm = permissions_in options[:in]
          if perm.nil?
            return false
          else
            return perm.mask & bits == bits
          end
        else
          warn "You haven't given an object or circle to search on. Failing silently. Argument list: #{args.inspect}"
        end
        # Failsafe to false
        false
      end

      def revoke! *args
        options = args.extract_options!
        options.assert_valid_keys(:in)

        # We're only using this if there are circles- not on generic objects, which should be INSIDE circles
        raise PermissiveError, "Must be called with a circle as an argument" if options[:in].nil?

        bits = args.map{|s| Permission.bit_for s}.inject(0){|sum, p| sum + p }

        #Get the permissions and return
        perm = permissions_in options[:in]

        if args.include? :all
          perm.destroy
        else
          perm.mask = perm.mask ^ bits if perm.mask & bits
          perm.save!
        end

        # Remove from circle and destroy permissions if the mask is zero
        perm.destroy! if perm.mask == 0
      end
    end
  end
end