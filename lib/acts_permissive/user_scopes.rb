module ActsPermissive
  module UserScopes

    # perform the 3 table join in a way that will
    # let us also call include and other filters.
    def owners_of_group group
      joins(:memberships).where('memberships.role_id = ? AND memberships.group_id = ?', Role.owner.id, group.id).select("DISTINCT `users`.*")
    end

    def admins_of_group group
      joins(:memberships).where('memberships.role_id = ? AND memberships.group_id = ?', Role.admin.id, group.id).select("DISTINCT `users`.*")
    end

    def readers_of_group group
      joins(:memberships).where('memberships.role_id = ? AND memberships.group_id = ?', Role.read.id, group.id).select("DISTINCT `users`.*")
    end

    def writers_of_group group
      joins(:memberships).where('memberships.role_id = ? AND memberships.group_id = ?', Role.write.id, group.id).select("DISTINCT `users`.*")
    end

    def is_role_in_group? role, group
      Membership.by_user(self).by_role(role).by_group(group) != nil
    end

    def is_member_of? group
      Membership.by_user(self).by_group(group) != nil
    end

    def roles_in group
      roles = []
      Membership.by_user(self).by_group(group).each do |membership|
        roles << membership.role
      end
      roles
    end

    def roleset_in group
      self.roles_in(group).inject(0) { |result, role| result | role.binary}
    end

  end

end