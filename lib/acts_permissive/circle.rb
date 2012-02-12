module ActsPermissive
  class Circle < ActiveRecord::Base

    has_many    :permissive_circlings, :dependent => :destroy

    set_table_name  :permissive_circles
    validates_presence_of :guid
    before_validation :create_guid!
    before_save :set_name!

    scope :by_user, lambda { |user|
      joins("inner join permissive_groupings on permissive_groupings.permissible_id = #{user.id} AND permissive_groupings.permissible_type = '#{user.class.to_s}'").
        joins("inner join permissive_permissions on permissive_permissions.id = permissive_groupings.permission_id").
        where("permissive_circles.id = permissive_permissions.circle_id").
        select("DISTINCT permissive_circles.*")
    }

    def items
      Circling.items_in self
    end

    def users
      Grouping.by_circle(self).map{|c| c.permissible }.compact
    end

    private

    def create_guid!
      self.guid = UUIDTools::UUID.random_create.to_str if self.guid.nil?
    end

    def set_name!
      self.name = self.guid if self.name.nil?
    end

  end
end