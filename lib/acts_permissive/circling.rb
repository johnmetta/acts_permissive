module ActsPermissive
  class Circling < ActiveRecord::Base

    belongs_to  :circle
    belongs_to  :circleable, :polymorphic => true
    belongs_to  :usable,  :polymorphic => true

    set_table_name  :permissive_circlings

    validates_uniqueness_of :circle_id, :scope => [:circleable_type, :circleable_id]

    class << self
      ## Return all items in the circle. Not that this could simply be done with the one line
      ##   where(:circle_id => circle.id).map{|c| c.circleable}.compact
      ## if we were not allowing ActiveResource associations in our circles. However, given
      ## that we are, ActiveResource models have no way to automatically translate from
      ## 'circleable' to the model because they are missing the 'scoped' method. Thus, we
      ## catch that no method error and instantiate the model manually. It's possible
      ## we could do this by opening ActiveResource, but I thought this was less intrusive
      def items_in circle
        lst = where(:circle_id => circle.id).map do |c|
          begin
            c.circleable
          rescue NoMethodError
            c.circleable_type.constantize.find(c.circleable_id)
          end
        end
        lst.compact
      end
    end
  end
end
