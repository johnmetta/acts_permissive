module ActsPermissive
  class Circling < ActiveRecord::Base

    belongs_to  :circle
    belongs_to  :circleable, :polymorphic => true
    belongs_to  :usable,  :polymorphic => true

    set_table_name  :permissive_circlings

    validates_uniqueness_of :circle_id, :scope => [:circleable_type, :circleable_id]

    class << self
      def items_in circle
        where(:circle_id => circle.id).map{|c| c.circleable }.compact
      end
    end
  end
end
