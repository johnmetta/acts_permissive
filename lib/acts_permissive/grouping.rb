module ActsPermissive
  class Grouping < ActiveRecord::Base

    belongs_to :permission
    belongs_to :permissible, :polymorphic => true

    set_table_name :permissive_groupings

    validates_uniqueness_of :permission_id, :scope => [:permissible_id, :permissible_type]

    scope :by_circle, lambda {|circle|
        joins("inner join permissive_permissions on permissive_permissions.circle_id == #{circle.id}").
        where("permissive_groupings.permission_id == permissive_permissions.id").
        select("DISTINCT `permissive_groupings`.*")
    }

    scope :by_object, lambda {|obj|
      joins("left outer join permissive_circlings on permissive_circlings.circleable_type == '#{obj.class.to_s}' AND permissive_circlings.circleable_id == #{obj.id}").
      joins("left outer join permissive_permissions on permissive_permissions.circle_id == permissive_circlings.id").
      where("permissive_groupings.permission_id == permissive_permissions.id").
      select("DISTINCT `permissive_groupings`.*")
    }

  end
end