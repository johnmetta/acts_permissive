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
      # somewhat of a hack...
      self.find_by_sql("
        SELECT DISTINCT pg.*
        FROM (
          SELECT circle_id
          FROM permissive_circlings
          WHERE circleable_id == #{obj.id}
          AND circleable_type == '#{obj.class.to_s}') pc
          INNER JOIN permissive_permissions pp
            ON pc.circle_id == pp.circle_id
          INNER JOIN permissive_groupings pg
            ON pg.permission_id == pp.id
      ")
    }

  end
end