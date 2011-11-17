class ActsPermissiveMigration < ActiveRecord::Migration
  def self.up
    create_table :permissive_permissions do |t|
      t.integer :circle_id
      t.integer :mask, :null => false, :default => 0
    end

    create_table :permissive_groupings do |t|
      t.integer :permission_id
      t.integer :permissible_id
      t.string  :permissible_type
    end

    create_table :permissive_circles do |t|
      t.string  :name
      t.string  :guid

      t.timestamps
    end

    create_table :permissive_circlings do |t|
      t.string    :circleable_type
      t.integer   :circleable_id
      t.string    :ownable_type
      t.integer   :ownable_id
      t.integer   :circle_id
    end

    add_index :permissive_permissions, :circle_id, :name => "circles_index"
    add_index :permissive_permissions, :mask, :name => "masks_masks"

    add_index :permissive_groupings, [:permissible_id, :permissible_type], :name => "grouper_index"
    add_index :permissive_groupings, :permission_id, :name => "permission_grouping_index"

    add_index :permissive_circles, :guid, :name => "circle_guids_index"
    add_index :permissive_circles, :name, :name => "circle_name_index"

    add_index :permissive_circlings, [:circleable_id, :circleable_type], :name => "thing_circling_index"
    add_index :permissive_circlings, [:ownable_id, :ownable_type], :name => "user_circling_index"
    add_index :permissive_circlings, :circle_id, :name => "circle_circling_index"
  end

  def self.down
    drop_table :permissive_circles
    drop_table :permissive_permissions
  end
end
