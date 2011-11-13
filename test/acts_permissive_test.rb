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
      assert @sam.respond_to? :power_set_in
      assert @sam.respond_to? :reads?
      assert @sam.respond_to? :writes?
      assert @sam.respond_to? :admins?
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
      @thing = Factory :thing
      @john = Factory :john
    end

    should "correctly set the 256 bit for ownership" do
      @john.make_owner_of @thing
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

  context "power set" do

    setup do
      Membership.delete :all
      @thing = Factory :thing
      @sam = Factory :sam
      @john = Factory :john

      # manually create some memberships
      # give sam 256 permissions- owner
      Membership.create :user_id => @sam.id, :circle_id => @thing.circle.id, :power => Membership.binary_owner
      #give john 64 and 32 permissions- write & read
      Membership.create :user_id => @john.id, :circle_id => @thing.circle.id, :power => Membership.binary_write
      Membership.create :user_id => @john.id, :circle_id => @thing.circle.id, :power => Membership.binary_read
    end

    should "return the correct powers as list" do
      roles = @john.powers_in @thing
      assert roles.length == 2
      assert_kind_of Array, roles
      assert roles.include?(Membership.binary_write)
      assert roles.include?(Membership.binary_read)
      assert roles.include?(Membership.binary_owner) == false
    end

    should "return the correct power set" do
      assert @john.power_set_in(@thing) == 32 + 64
      assert @sam.power_set_in(@thing) == 256
    end

  end

  context "boolean functions" do
    setup do
      Membership.delete :all
      @thing = Factory :thing
      @sam = Factory :sam
      @bob = Factory :bob
      @john = Factory :john
      @john.make_owner_of @thing
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

      assert @sam.can_read?(@thing) == false
      assert @sam.can_write?(@thing) == false

      assert @bob.can_read?(@thing)
      assert @bob.can_write?(@thing) == false
    end

  end

end
