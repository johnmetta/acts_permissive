# Introduction

Individualized role and permission management system for Rails

## Installation

gem 'acts_permissive'
bundle install
rails generate acts_permissive
rake db:migrate

class Thing < ActiveRecord::Base
  is_used_permissively
end

class AnotherThing <ActiveRecord::Base
  is_used_permissively
end

class User < ActiveRecord::Base
  acts_permissive
end

## The simple examples

big_guy = User.create_as_owner Thing, {:name => "this instance of thing"}

little_guy = User.create
little_guy.can_see? thing -> false

big_guy.grants.read.on(thing).to(little_guy)

little_guy.can_see? thing -> true
little_guy.can_read? thing -> true
little_guy.can_write? thing -> false

another_guy = User.create

another_guy = can_see? thing -> false

big_guy.grants.admin.on(thing).to(another_guy)

another_guy.can_see? thing -> true
another_guy.can_read? thing -> false
another_guy.can_write? thing -> false
another_guy.can_admin? thing -> true

another_guy.grants.write.on(thing).to(little_guy)

little_guy.can_write? thing -> true

# The Gory Details

Every "thing" that is_used_permissively has a suite of permissions that are possible on it.
The permissions are binary and additive and users who are acts_permissive can have any arbitrary
collection of those permissions on any individual object. Permissions are stored in a join table
which basically has three properties- the object's "circle" (a polymorphic model), the user, and
the "power." Power is a string of 1s and 0s representing a permission set.

## acts_permissive

Objects that call acts_permissive (currently, this should really just be one single User object)
are given the ability to hold byte-additive permissions on individual object instances.

## is_used_permissively

## Membership


