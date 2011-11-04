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

  context "user methods" do
    setup do
      @container = ActsPermissive::MembershipContainer.new
      @user = Factory :sam
    end

    should "Set the correct values" do
      @container.to(@user) == @container
      @container.user == @user
      not @container.valid?
    end
  end

  context "circle methods" do

    setup do
      @container = ActsPermissive::MembershipContainer.new
      @circle = ActsPermissive::Circle.new
    end

    should "Set the correct value" do
      @container.on(@circle) == @container
      @container.circle == @circle
      not @container.valid?
    end
  end

  context "partial chain" do

    should "Not create membership for only role and user" do
      container = ActsPermissive::MembershipContainer.new
      user = Factory :sam
      container.read.to(user) == container
    end

    should "Not create membership for only role and circle" do
      container = ActsPermissive::MembershipContainer.new
      circle = ActsPermissive::Circle.new
      container.read.on(circle) == container
    end

    should "Not create membership for only user and circle" do
      container = ActsPermissive::MembershipContainer.new
      user = Factory :sam
      circle = ActsPermissive::Circle.new
      container.on(circle).to(user) == container
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