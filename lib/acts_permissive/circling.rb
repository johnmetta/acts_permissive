module ActsPermissive
  class Circling < ActiveRecord::Base

    belongs_to  :circle
    belongs_to  :thing_circler, :polymorphic => true
    belongs_to  :user_circler,  :polymorphic => true

    set_table_name  :permissive_circlings
  end
end
