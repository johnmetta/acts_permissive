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

    should "correctly set the 256 bit for ownership"

  end

  context "power set" do

    setup do
      ActsPermissive::Membership.delete :all
      @thing = Factory :thing
      @sam = Factory :sam
      @john = Factory :john

      # manually create some memberships
      # give sam 256 permissions- owner
      ActsPermissive::Membership.create :user_id => @sam.id, :circle_id => @thing.circle.id, :power => ActsPermissive::Membership.owner
      #give john 64 and 32 permissions- write & read
      ActsPermissive::Membership.create :user_id => @john.id, :circle_id => @thing.circle.id, :power => ActsPermissive::Membership.write
      ActsPermissive::Membership.create :user_id => @john.id, :circle_id => @thing.circle.id, :power => ActsPermissive::Membership.read
    end

    should "return the correct powers as list" do
      roles = @john.powers_in @thing
      assert roles.length == 2
      assert roles.include?(ActsPermissive::Membership.read)
      assert roles.include?(ActsPermissive::Membership.write)
      assert roles.include?(ActsPermissive::Membership.owner) == false
    end

    should "return the correct power set" #do
#      @john.power_set_in(@thing) == 32 + 64
#      @sam.power_set_in(@thing) == 256
#    end

  end

end
