ActiveRecord::Schema.define :version => 0 do

  create_table :memberships, :force => true do |t|
    t.integer :user_id
    t.integer :circle_id
    t.integer :role_id
  end

  create_table :circles, :force => true do |t|
    t.string :name
    t.string :guid
    t.boolean :is_hidden
    t.integer :circleable_id
    t.string  :circleable_type
  end

  create_table :roles, :force => true do |t|
    t.string :name
    t.binary :power, :limit => 1.byte
  end

end
