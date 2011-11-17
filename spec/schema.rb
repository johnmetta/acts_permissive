ActiveRecord::Schema.define :version => 0 do

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

end
