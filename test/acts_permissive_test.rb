require 'test_helper'

class ActsPermissiveTest < ActiveSupport::TestCase

  context "module" do

    should "load ActsPermissive as a module" do
      assert_kind_of Module, ActsPermissive
    end

    should "load PermissiveUser as a module" do
      assert_kind_of Module, ActsPermissive::PermissiveUser
    end

  end

  context "instance methods" do

    setup do
      @sam = Factory :sam
    end

    should "be defined" do
      assert @sam.respond_to? :memberships
      assert @sam.respond_to? :is_role_in_circle?
      assert @sam.respond_to? :is_member_of?
      assert @sam.respond_to? :roles_in
      assert @sam.respond_to? :roleset_in
      assert @sam.respond_to? :can_read?
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

  context "User method chaining" do

    should "Return an empty membership container" do
      sam = Factory :sam
      john = Factory :john
      circle = ActsPermissive::Circle.new
      result = john.grant.read.to(sam).on(circle)
      result == true
    end
  end
end
