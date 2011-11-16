module ActsPermissive
  class Permission < ActiveRecord::Base

    has_many    :groupings
    belongs_to  :permissible, :polymorphic => true
    belongs_to  :circle

    validates_presence_of :circle, :permissive_user, :mask
    set_table_name  :permissive_permissions
    scope :on, lambda { |circle|
      {:conditions => ['circle_id = ?', circle.id]}
    }
    scope :for, lambda { |user|
      {:conditions => ['permissible_id = ? AND permissible_type = ?', user.id, user.class.to_s]}
    }

  end
end