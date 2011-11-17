module ActsPermissive
  class Circling < ActiveRecord::Base

    belongs_to  :circle
    belongs_to  :circleable, :polymorphic => true
    belongs_to  :usable,  :polymorphic => true

    set_table_name  :permissive_circlings

    scope :items_in, lambda { |circle|
      where(:circle_id => circle.id).map{|c| c.circleable}.compact
    }
    scope :users_in, lambda { |circle|
      where(:circle_id => circle.id).map{|c| c.usable}.compact
    }

  end
end
