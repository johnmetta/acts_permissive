ActiveRecord::Schema.define :version => 0 do

  create_table :memberships, :force => true do |t|
    t.integer :user_id
    t.integer :circle_id
    t.string :power, :null => false, :default => '000000000'
  end

  create_table :circles, :force => true do |t|
    t.string :name
    t.string :guid
    t.boolean :is_hidden
    t.integer :circleable_id
    t.string  :circleable_type
  end

end
