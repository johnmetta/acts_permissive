require 'test_helper'

class ActsPermissiveTest < ActiveSupport::TestCase
  def setup
    ActsPermissive::Role.create(:name => "owner", :power => '1000')
    ActsPermissive::Role.create(:name => "admin", :power => '0100')
    ActsPermissive::Role.create(:name => "write", :power => '0010')
    ActsPermissive::Role.create(:name => "read",  :power => '0001')
  end
  def teardown
    ActsPermissive::Role.owner.destroy
    ActsPermissive::Role.admin.destroy
    ActsPermissive::Role.write.destroy
    ActsPermissive::Role.read.destroy
  end

  context "module" do

    should "load ActsPermissive as a module" do
      assert_kind_of Module, ActsPermissive
    end

    should "load PermissiveUser as a module" do
      assert_kind_of Module, ActsPermissive::PermissiveUser
    end

    should "create roles" do
      assert ActsPermissive::Role.owner.binary == 8
    end

  end

  context "instance methods" do

    setup do
      @sam = Factory :sam
    end

    should "be defined" do
      assert @sam.respond_to? :memberships
      assert @sam.respond_to? :is_member_of?
      assert @sam.respond_to? :roles_in
      assert @sam.respond_to? :roleset_in
      assert @sam.respond_to? :reads?
      assert @sam.respond_to? :writes?
      assert @sam.respond_to? :admins?
      assert @sam.respond_to? :owns?
      assert @sam.respond_to? :grant
      assert @sam.respond_to? :revoke
      assert @sam.respond_to? :grants
      assert @sam.respond_to? :revokes
    end

  end

  context "class methods" do

    should "be defined" do
      assert User.respond_to? :owners_of_circle
      assert User.respond_to? :admins_of_circle
      assert User.respond_to? :readers_of_circle
      assert User.respond_to? :writers_of_circle
    end

  end

  context "roleset" do

    should "return the correct roles as list" do
      thing = Factory :thing
      john = Factory :john
      john.make_owner_of thing

      assert john.roles_in(thing).include?(ActsPermissive::Role.owner)
#      assert john.roles_in(thing).include?(ActsPermissive::Role.admin) == false

      ActsPermissive::Membership.create :user => john, :circle => thing.circle, :role => ActsPermissive::Role.admin

      assert john.roles_in(thing).include?(ActsPermissive::Role.admin)
    end

    should "return the correct role" do
      thing = Factory :thing
      john = Factory :john
      sam = Factory :sam
      john.make_owner_of thing

#      assert john.owns?(thing)
#      assert sam.owns?(thing) == false
    end

  end

    context "reading" do
      setup do
        @sam = Factory :sam
        @john = Factory :john
        @bob = Factory :bob
        @circle = ActsPermissive::Circle.new
        ActsPermissive::Membership.create :user => @john, :circle => @circle, :role => ActsPermissive::Role.owner
        @thing = Factory :thing
        @john.make_owner_of @thing
      end

      should "Return grant read access to a user on a circle" do
        assert @sam.reads?(@circle) == false
        result = @john.grants.read.to(@sam).on(@circle)
        assert result
        assert @sam.reads?(@circle)
        assert @sam.writes?(@circle) == false
        assert @sam.admins?(@circle) == false
        assert @sam.owns?(@circle) == false
        assert @bob.reads?(@circle) == false
      end

      should "Return grant read access to a user on a thing" do
        assert @sam.reads?(@thing) == false
        result = @john.grants.read.to(@sam).on(@thing)
        assert result
        assert @sam.reads?(@thing)
        assert @sam.writes?(@thing) == false
        assert @sam.admins?(@thing) == false
        assert @sam.owns?(@thing) == false
        assert @bob.reads?(@thing) == false
      end

    end
    context "writing" do
      setup do
       @sam = Factory :sam
       @john = Factory :john
       @bob = Factory :bob
       @circle = ActsPermissive::Circle.new
       @thing = Factory :thing
       ActsPermissive::Membership.create :user => @john, :circle => @circle, :role => ActsPermissive::Role.owner
       @john.make_owner_of @thing
      end

      should "Return grant read access to a user on a circle" do
        assert @sam.writes?(@circle) == false
        result = @john.grants.write.to(@sam).on(@circle)
        result
        assert @sam.reads?(@circle) == false
        assert @sam.writes?(@circle)
        assert @sam.admins?(@circle) == false
        assert @sam.owns?(@circle) == false
        assert @bob.reads?(@circle) == false
      end

      should "Return grant read access to a user on a thing" do
        assert @sam.writes?(@thing) == false
        result = @john.grants.write.to(@sam).on(@thing)
        result
        assert @sam.reads?(@thing) == false
        assert @sam.writes?(@thing)
        assert @sam.admins?(@thing) == false
        assert @sam.owns?(@thing) == false
        assert @bob.reads?(@thing) == false
      end

    end
    context "admin" do
      setup do
       @sam = Factory :sam
       @john = Factory :john
       @bob = Factory :bob
       @circle = ActsPermissive::Circle.new
       @thing = Factory :thing
       ActsPermissive::Membership.create :user => @john, :circle => @circle, :role => ActsPermissive::Role.owner
       @john.make_owner_of @thing
      end

      should "Return grant read access to a user on a circle" do
        assert @sam.admins?(@circle) == false
        result = @john.grants.admin.to(@sam).on(@circle)
        result
        assert @sam.reads?(@circle)  == false
        assert @sam.writes?(@circle) == false
        assert @sam.admins?(@circle)
        assert @sam.owns?(@circle) == false
        assert @bob.reads?(@circle) == false
      end

      should "Return grant read access to a user on a thing" do
        assert @sam.admins?(@thing) == false
        result = @john.grants.admin.to(@sam).on(@thing)
        result
        assert @sam.reads?(@thing)  == false
        assert @sam.writes?(@thing) == false
        assert @sam.admins?(@thing)
        assert @sam.owns?(@thing) == false
        assert @bob.reads?(@thing) == false
      end

    end
    context "owner" do
      setup do
       @sam = Factory :sam
       @john = Factory :john
       @bob = Factory :bob
       @circle = ActsPermissive::Circle.new
       @thing = Factory :thing
       ActsPermissive::Membership.create :user => @john, :circle => @circle, :role => ActsPermissive::Role.owner
       @john.make_owner_of @thing
      end

      should "Return grant read access to a user on a circle" do
        assert @sam.owns?(@circle) == false
        result = @john.grants.ownership.to(@sam).on(@circle)
        result
        assert @sam.reads?(@circle)
        assert @sam.writes?(@circle)
        assert @sam.admins?(@circle)
        assert @sam.owns?(@circle)
        assert @bob.reads?(@circle) == false
      end

      should "Return grant read access to a user on a thing" do
        assert @sam.reads?(@thing) == false
        result = @john.grants.ownership.to(@sam).on(@thing)
        result
        assert @sam.reads?(@thing)
        assert @sam.writes?(@thing)
        assert @sam.admins?(@thing)
        assert @sam.owns?(@thing)
        assert @bob.reads?(@thing) == false
      end

      context "granting permissions" do
        setup do
         @sam = Factory :sam
         @john = Factory :john
         @bob = Factory :bob
         @circle = ActsPermissive::Circle.new
         @thing = Factory :thing
         ActsPermissive::Membership.create :user => @john, :circle => @circle, :role => ActsPermissive::Role.owner
         @john.make_owner_of @thing
        end

        should "Not allow granting of permissions if user is not anything" do
          assert_raise(ActsPermissive::PermissiveException) { @sam.grants.read.on(@thing).to(@bob)}
          assert_raise(ActsPermissive::PermissiveException) { @bob.grants.write.on(@thing).to(@sam)}
          assert_raise(ActsPermissive::PermissiveException) { @sam.grants.admin.on(@thing).to(@bob)}
          assert_raise(ActsPermissive::PermissiveException) { @bob.grants.owner.on(@thing).to(@sam)}
        end

        should "Allow granting of read/write by admin" do
          @john.grants.admin.on(@thing).to(@sam)
          assert @sam.grants.read.on(@thing).to(@bob)
        end
      end

    end
end
