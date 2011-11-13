require 'test_helper'

class MembershipTest < ActiveSupport::TestCase

  context "class" do
    setup do
      assert_kind_of Class, Membership
    end
  end

  context "class methods" do

    should "be defined" do
      assert Membership.respond_to? :binary_owner
      assert Membership.respond_to? :binary_admin
      assert Membership.respond_to? :binary_write
      assert Membership.respond_to? :binary_read
      assert Membership.respond_to? :by_user
      assert Membership.respond_to? :by_circle
      assert Membership.respond_to? :by_power
    end

    should "correctly create owner string" do
      assert_kind_of String, Membership.binary_owner
      assert Membership.binary_owner == "100000000"
    end
    should "correctly create admin string" do
      assert_kind_of String, Membership.binary_admin
      assert Membership.binary_admin == "010000000"
    end
    should "correctly create write string" do
      assert_kind_of String, Membership.binary_write
      assert Membership.binary_write == "001000000"
    end
    should "correctly create read string" do
      assert_kind_of String, Membership.binary_read
      assert Membership.binary_read == "000100000"
    end
  end

  context "instance methods" do
    setup do
      @membership = Membership.new
    end

    should "be defined"
  end
end