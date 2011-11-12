module ActsPermissive
  class Circle < ActiveRecord::Base

    belongs_to :circleable, :polymorphic => true
    has_many :memberships
    has_many :users,        :through => :memberships

    before_create :create_guid!
    validates_uniqueness_of :guid

    attr_accessor :name, :guid, :is_hidden, :is_public

    scope :by_user, lambda { |user|
      joins(:memberships).where('memberships.user_id = ?', user.id).select("DISTINCT `circles`.*")
    }
    scope :by_power, lambda { |power|
      joins(:memberships).where('memberships.power = ?', power).select("`circles`.*")
    }
    scope :by_user_id, lambda { |user_id|
      joins(:memberships).where('memberships.user_id = ?', user_id).select("DISTINCT `circles`.*")
    }
    scope :by_hidden, lambda { |hidden|
      where('is_hidden = ?', hidden)
    }

    def create_guid!
      self.guid = UUIDTools::UUID.random_create.to_str
      self.is_public == false if self.is_public.nil?
    end

  end
end