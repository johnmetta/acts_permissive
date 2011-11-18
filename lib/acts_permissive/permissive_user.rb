module ActsPermissive
  module PermissiveUser

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_permissive
        include ActsPermissive::PermissiveUser::InstanceMethods

        has_many  :circlings, :as => :usable, :class_name => "ActsPermissive::Circling"
        has_many  :circles, :through => :circlings, :class_name => 'ActsPermissive::Circle',:dependent => :destroy
        has_many :groupings, :as => :permissible, :class_name => "ActsPermissive::Grouping"
        has_many :permissions, :through => :groupings, :class_name => "ActsPermissive::Permission", :dependent => :destroy

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
        #TODO: Check permissions on objects before adding them!
        params[:objects].select{|o| o.respond_to? :is_used_permissively?}.each{ |o| o.add_to circle}

        #return for use
        circle
      end

      def permissions_in circle
        Permission.for(self).in(circle).first
      end

      def can! *args
        options = args.extract_options!
        options.assert_valid_keys(:in, :reset)

        # We're only using this if there are circles- not on generic objects, which should be INSIDE circles
        raise PermissiveError, "Must be called with a circle as an argument" if options[:in].nil?

        #get the permission, or build it if it doesn't exist
        perm = permissions_in(options[:in]) || permissions.build(:circle => options[:in])

        # Reset the permission if that's what we're into
        perm.reset if options[:reset]

        # For each permission, bitwise OR them together unless we have a zero, in which case we just ignore
        args.select{|o| o.class == Symbol}.each do |name|
          bit = Permission.bit_for name
          perm.mask = perm.mask & bit != 0 ? 0 : perm.mask | bit
        end

        raise PermissiveError, "Cannot save permission: #{perm.errors}" if not save!
        perm
      end

      def can? *args
        options = args.extract_options!
        options.assert_valid_keys(:in, :reset, :see)

        #if we're checking for :see, return right away
        if options[:see]
          return permissions_in(options[:see]).present?
        end

        # We're only using this if there are circles- not on generic objects, which should be INSIDE circles
        raise PermissiveError, "Must be called with a circle as an argument" if options[:in].nil?

        #Get the permissions and return
        perm = permissions_in options[:in]
        if perm.nil?
          false
        else
          #add up the bits and do a bitwise and to check permissions
          bits = args.select{|o| o.class == Symbol}.map{|s| Permission.bit_for s}.inject(0){|sum, p| sum + p }
          perm.mask & bits == bits
        end
      end

      def revoke! *args

      end
    end
  end
end