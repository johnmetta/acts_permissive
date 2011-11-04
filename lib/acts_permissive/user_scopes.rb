module ActsPermissive
  module UserScopes

    # perform the 3 table join in a way that will
    # let us also call include and other filters.
    def owners_of_circle circle
      joins(:memberships).where('memberships.role_id = ? AND memberships.circle_id = ?', Role.owner.id, circle.id).select("DISTINCT `users`.*")
    end

    def admins_of_circle circle
      joins(:memberships).where('memberships.role_id = ? AND memberships.circle_id = ?', Role.admin.id, circle.id).select("DISTINCT `users`.*")
    end

    def readers_of_circle circle
      joins(:memberships).where('memberships.role_id = ? AND memberships.circle_id = ?', Role.read.id, circle.id).select("DISTINCT `users`.*")
    end

    def writers_of_circle circle
      joins(:memberships).where('memberships.role_id = ? AND memberships.circle_id = ?', Role.write.id, circle.id).select("DISTINCT `users`.*")
    end

  end

end