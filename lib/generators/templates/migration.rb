class ActsPermissiveMigration < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :circle_id
      t.integer :role_id

      t.timestamps
    end

    create_table :circles do |t|
      t.string :name
      t.string :guid
      t.boolean :is_hidden
      t.boolean :is_public, :default => false
      t.integer :circleable_id
      t.string  :circleable_type

      t.timestamps
    end

    create_table :roles do |t|
      t.string :name
      t.string :power

      t.timestamps
    end

  end

  def self.down
    drop_table :memberships
    drop_table :circles
    drop_table :roles
  end
end
