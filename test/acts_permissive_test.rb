require 'test_helper'

class ActsPermissiveTest < ActiveSupport::TestCase
  context "module" do

    should "load ActsPermissive as a module" do
      assert_kind_of Module, ActsPermissive
    end

    should "load PermissiveUser as a module" do
      assert_kind_of Module, ActsPermissive::PermissiveUser
    end

    should "load PermissiveLib as a module" do
      assert_kind_of Module, ActsPermissive::PermissiveLib
    end

  end

  context "instance methods" do

    setup do
      @sam = Factory :sam
    end

    should "be defined" do
      assert @sam.respond_to? :memberships
      assert @sam.respond_to? :is_member_of?
      assert @sam.respond_to? :powers_in
      assert @sam.respond_to? :can_read?
      assert @sam.respond_to? :can_write?
      assert @sam.respond_to? :can_admin?
      assert @sam.respond_to? :owns?
      assert @sam.respond_to? :grant
      assert @sam.respond_to? :revoke
      assert @sam.respond_to? :grants
      assert @sam.respond_to? :revokes
    end

    should "announce that it is permissive" do
      assert @sam.is_permissive?
    end

  end

  context "class methods" do

    should "be defined" do
      assert User.respond_to? :owners_of
      assert User.respond_to? :admins_of
      assert User.respond_to? :readers_of
      assert User.respond_to? :writers_of
    end

  end

  context "make owner" do
    setup do
      @john = Factory :john
      @thing = @john.create_as_owner Thing, Factory.attributes_for(:thing)
    end

    should "correctly set the 256 bit for ownership" do
      mems = Membership.find(:all, :conditions => {:user_id => @john.id, :circle_id => @thing.circle.id})
      assert mems.length == 1
      assert mems[0].power == Membership.binary_owner
    end

  end

  context "granting and revoking" do
    setup do
      @john = Factory :john
    end

    should "create a proper MembershipContainer on grant" do
      mc = @john.grants
      assert mc.calling_user == @john
      assert mc.grant
    end

    should "create a proper MembershipContainer on revoke" do
      mc = @john.revokes
      assert mc.calling_user == @john
      assert mc.grant == false
    end
  end

  context "creation" do
    should "Create an object correctly" do
      john = Factory :john
      thing = john.create_as_owner Thing
      assert_instance_of Thing, thing
    end

    should "Set parameters on creation" do
      john = Factory :john
      thing = john.create_as_owner Thing, {:name => "blah"}
      assert thing.name == "blah"
    end
  end

  context "power set" do

    setup do
      Membership.delete :all
      @sam = Factory :sam
      @thing = @sam.create_as_owner Thing
      @john = Factory :john
      @sam.grant.read.on(@thing).to(@john)
      @sam.grant.write.on(@thing).to(@john)
    end

    should "return the correct power set" do
      puts @john.powers_in(@thing)
      assert @john.powers_in(@thing) == 16 + 32
      assert @sam.powers_in(@thing) == 255
    end

  end

  context "boolean functions" do
    setup do
      Membership.delete :all
      @sam = Factory :sam
      @bob = Factory :bob
      @john = Factory :john
      @thing = @john.create_as_owner Thing, Factory.attributes_for(:thing)
      @john.grants.admin.on(@thing).to(@sam)
      @sam.grants.read.on(@thing).to(@bob)
    end

    should "show correct ownership" do
      assert @john.owns? @thing
      assert @sam.owns?(@thing) == false
      assert @bob.owns?(@thing) == false
    end

    should "show correct admin privileges" do
      assert @john.can_admin? @thing
      assert @sam.can_admin? @thing
      assert @bob.can_admin?(@thing) == false
    end

    should "show correct read/write privileges" do
      assert @john.can_read? @thing
      assert @john.can_write? @thing

      assert @sam.can_read?(@thing)
      assert @sam.can_write?(@thing)

      assert @bob.can_read?(@thing)
      assert @bob.can_write?(@thing) == false
    end

  end

end
