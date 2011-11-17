module ActsPermissive
  class Circling < ActiveRecord::Base

    belongs_to  :circle
    belongs_to  :circleable, :polymorphic => true
    belongs_to  :ownable,  :polymorphic => true

    set_table_name  :permissive_circlings
  end
end
