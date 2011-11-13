require 'test_helper'

class MembershipTest < ActiveSupport::TestCase

  context "class" do
    setup do
      assert_kind_of Class, ActsPermissive::Membership
    end
  end

  context "class methods" do

    should "respond be defined" do
      assert ActsPermissive::Membership.respond_to? :owner
      assert ActsPermissive::Membership.respond_to? :admin
      assert ActsPermissive::Membership.respond_to? :write
      assert ActsPermissive::Membership.respond_to? :read
    end

    should "correctly create owner string" do
      assert ActsPermissive::Membership.owner == "100000000"
    end
    should "correctly create admin string" do
      assert ActsPermissive::Membership.admin == "010000000"
    end
    should "correctly create write string" do
      assert ActsPermissive::Membership.write == "001000000"
    end
    should "correctly create read string" do
      assert ActsPermissive::Membership.read == "000100000"
    end
  end
end