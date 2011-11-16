module ActsPermissive
  class Circle < ActiveRecord::Base

    has_many    :permissive_circlings
    belongs_to  :circleable, :polymorphic => true
    belongs_to  :ownable, :polymorphic => true

    set_table_name  :permissive_circles
    validates_presence_of :guid
    before_validation :create_guid!
    before_save :set_name!

    private

    def create_guid!
      self.guid = UUIDTools::UUID.random_create.to_str if self.guid.nil?
    end
    def set_name!
      self.name = self.guid if self.name.nil?
    end

  end
end