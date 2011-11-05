require 'test_helper'

class MembershipContainerTest < ActiveSupport::TestCase

  context "module" do

    should "load MembershipContainer as a class" do
      assert_kind_of Class, ActsPermissive::MembershipContainer
    end

  end

  context "role methods" do
    setup do
      @container = ActsPermissive::MembershipContainer.new
    end

    should "set the correct roles" do
      assert @container.read == @container
      assert @container.role == ActsPermissive::Role.read
      assert @container.write == @container
      assert @container.role == ActsPermissive::Role.write
      assert @container.owner == @container
      assert @container.role == ActsPermissive::Role.owner
      assert @container.admin == @container
      assert @container.role == ActsPermissive::Role.admin
    end
  end
  context "full chain" do

    should "Create a full membership with a full chain" do
      container = ActsPermissive::MembershipContainer.new
      user = Factory :sam
      circle = ActsPermissive::Circle.new
      result = container.read.on(circle).to(user)
      result == true
    end

  end
end