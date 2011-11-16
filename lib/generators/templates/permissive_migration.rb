class ActsPermissiveMigration < ActiveRecord::Migration
  def self.up
    create_table :permissive_permissions do |t|
      t.integer :permissible_id
      t.string  :permissible_type
      t.integer :permissive_circle_id
      t.integer :mask, :null => false, :default => 0
    end

    create_table :permissive_groupings do |t|
      t.integer :permissive_permission_id
      t.integer :grouper_id
      t.string  :grouper_type
    end

    create_table :permissive_circles do |t|
      t.string  :name
      t.string  :guid
      t.string  :circleable_type
      t.integer :circleable_id
      t.string  :ownable_type
      t.integer :ownable_id

      t.timestamps
    end

    create_table :permissive_circlings do |t|
      t.string    :thing_circler_type
      t.integer   :thing_circler_id
      t.string    :user_circler_type
      t.integer   :user_circler_id
      t.integer   :permissive_circle_id
    end

    add_index :permissive_permissions, [:permissive_user_id, :permissive_user_type], :name => "users_index"
    add_index :permissive_permissions, :circle_id, :name => "circles_index"
    add_index :permissive_permissions, :masx, :name => "masks_masks"
    add_index :permissive_circles, :guid, :name => "circle_guids_index"
    add_index :permissive_circles, [:circleable_id, :circleable_type], :name => "circle_objects_index"
    add_index :permissive_circles, [:ownable_id, :ownable_type], :name => "circle_owners_index"
  end

  def self.down
    drop_table :permissive_circles
    drop_table :permissive_permissions
  end
end
