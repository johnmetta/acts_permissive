module ActsPermissive
  class Permission < ActiveRecord::Base

    has_many    :groupings, :dependent => :destroy
    belongs_to  :circle

    validates_presence_of :circle, :mask
    set_table_name  :permissive_permissions

    scope :in, lambda { |circle|
      where("circle_id = #{circle.id}")
    }
    scope :for, lambda { |user|
      joins(:groupings).where("permissive_groupings.permissible_id = #{user.id} AND permissive_groupings.permissible_type = '#{user.class.to_s}'").readonly(false)
    }

    class << self
      def bit_for permission
        PermissionMap.hash[permission.to_s.downcase.to_sym] || 0
      end
    end

    def reset

    end
  end
end