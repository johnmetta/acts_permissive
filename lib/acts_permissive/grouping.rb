module ActsPermissive
  class Grouping < ActiveRecord::Base

    belongs_to :permission
    belongs_to :grouper, :polymorphic => true

    set_table_name :permissive_groupings
  end
end