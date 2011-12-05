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

      #TODO: Refactor this shit!
      def all_who_can *args
        # Get a list of users who can do whatever symbol based permissions are
        # listed. For instance
        # authors = @thing.all_who_can(:read, :write)
        all_users = []
        circles.each do |c|
          c.users.each do |u|
            all_users << u
          end
        end
        all_users.uniq!

        users = []

        args.each do |arg|
          all_users.map{|u| u.can?(arg)}.compact.each{|u| users << u}
        end
        users
      end
    end
  end
end