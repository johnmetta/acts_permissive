module ActsPermissive
  class Grouping < ActiveRecord::Base

    belongs_to :permission
    belongs_to :grouper, :polymorphic => true

    set_table_name :permissive_groupings

    validates_uniqueness_of :permission_id, :scope => [:permissible_id, :permissible_type]
  end
end