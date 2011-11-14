module ActsPermissive
  module UserScopes

    # perform the 3 table join in a way that will
    # let us also call include and other filters.
    def owners_of obj
      circle = get_circle_for obj
      joins(:memberships).where('memberships.power = ? AND memberships.circle_id = ?', 128.to_s(2).rjust(8,'0'), circle.id).select("DISTINCT `users`.*")
    end

    def admins_of obj
      circle = get_circle_for obj
      joins(:memberships).where('memberships.power = ? AND memberships.circle_id = ?', 64.to_s(2).rjust(8,'0'), circle.id).select("DISTINCT `users`.*")
    end

    def readers_of obj
      circle = get_circle_for obj
      joins(:memberships).where('memberships.power = ? AND memberships.circle_id = ?', 32.to_s(2).rjust(8,'0'), circle.id).select("DISTINCT `users`.*")
    end

    def writers_of obj
      circle = get_circle_for obj
      joins(:memberships).where('memberships.power = ? AND memberships.circle_id = ?', 16.to_s(2).rjust(8,'0'), circle.id).select("DISTINCT `users`.*")
    end

    def get_circle_for obj
      if obj.class == Circle
        obj
      elsif obj.is_used_permissively?
        obj.circle
      else
        raise "Argument must be a trust circle or an object that is used permissively"
      end
    end

  end

end