# ActsPermissive

This is a library that allows you to create arbitrary permissions on arbitrary groupings
of individual Rails models

What?

I know, that's confusing. But it's really cool once you get it. Keep reading.

# Installation

## Rails 3.1
    gem 'acts_permissive', :git => 'git://github.com/mettadore/acts_permissive.git', :branch => 'rails_3.1'

    bundle install

    rails generate acts_permissive

    rake db:migrate

## Loading

Somewhere in the initialisation (e.g. application.rb), define your arbitrary permissions:

    module ActsPermissive::PermissionMap
      VISIT = 0
      USE = 1
      HIDE = 2
      THROW_AWAY = 3
      READ = 4
      WRITE = 5
    end

User-like classes (things that have permissions) are loaded like this:

    class User < ActiveResource::Base
      acts_permissive
    end

    class Admin < ActiveResource::Base
      acts_permissive
    end

    Thing-like classes (things that you want to control permissions for) are loaded like this:

    class Thing < ActiveResource::Base
      is_used_permissively
    end

    class Widget < ActiveResource::Base
      is_used_permissively
    end

# Usage
It's all a bit complicated to talk about, because we're not used to being able to do this, but basically:

    private_circle = user_a.build_circle :name => "My Private Stuff"
    friend_circle = user_a.build_circle :name => "Stuff for my friends"

    journal = Thing.create :name => "Journal"
    photo = Thing.create :name => "photos"

    journal.add_to private_circle
    photo.add_to public_circle

    friend = User.create :name => "friend"

    friend.can! :read, :write, :in => public_circle
    friend.can! :read, :in => private_circle

    friend.can?(:read, :in => private_circle) -> true
    friend.can?(:write, :in => private_circle) -> false

    journal.all_who_can(:read).include?(friend) -> true

## Bigger example (i.e. Who's allowed in your bedroom?)

Think about the 'circle of trust.' You have a house, and certain people are allowed in your house.
It's not everyone in the world, it's people in your "house circle of trust." Of all the people in
your house, a certain sub-set of them are allowed, say, in your bedroom-- you have a separate
"bedroom circle of trust." Now, friends might come over and hang out in your bedroom and watch
a scary movie with you, but not all of them are allowed, say, in your underwear drawer-- that's
an even smaller "underwear drawer circle of trust."

That's how acts_permissive works. It's based on the "circle of trust" for specific collections
 of Rails objects.

So, there are some people. There's me:
    john = User.create :name => "John"

and there are others:
    wife = User.create :name => "Jessica"
    buddy = User.create :name => "Bill"
    boss = Admin.create :name => "Hugh"

And there are some things that I want to control access to:
    tv = Thing.create :name => "television"
    couch = Thing.create :name => "couch"
    stapler = Widget.create :name => "Swingline"
    toothbrush = Widget.create :name => "toothbrush"

So, I make some "access control groupings" (i.e. circles of trust)

    public = john.build_circle :name => "My House"
    private = john.build_circle :name => "My Bedroom"
    world = john.build_circle :name => "Everything"

And I put the "things" in the "circles"

    tv.add_to public, world
    couch.add_to public, world
    stapler.add_to private, world
    toothbrush.add_to private, world

Then, I can control who can do what, with what:

    wife.can!(:use, :hide, :throw_away, :in => private)
    wife.can!(:visit, :use, :hide, :throw_away, :in => private)
    buddy.can!(:use, :in => public)
    boss.can!(:visit, :in => public)

The permissions are arbitrary, but are best named with a verb. With permissions set, we can
query them:

Queries are based on the circle:

    buddy.can?(:see => private) -> false
    wife.can?(:see => private) -> true
    wife.can?(:throw_away, :in => private) -> true
    boss.can?(:use, :in => private) -> false

Object also has a some query methods:

    toothbrush.who_can_see -> [john, wife]
    tv.all_who_can(:use) -> [john, wife, bill]

    toothbrush.all_who_can(:use).include? wife -> true

Note: It might be useful to have a can? method that can act on the individual object, such as

    boss.can(:use, stapler) -> false

But I've opted to leave that in the application's solution space, since this gem focuses on
the circle of objects, not the individual object as much.

You can also get all users in a circle, regardless of type

    private.users -> [john, wife]
    public.users -> [john, wife, bill, boss]

and all the objects in a circle, regardless of type:

    private.items -> [stapler, toothbrush]
    world.items -> [stapler, toothbrush, couch, tv]


