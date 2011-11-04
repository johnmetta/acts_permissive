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
      assert @sam.respond_to? :is_permissive?
    end

  end

  context "class methods" do

    should "be defined" do
      assert User.respond_to? :owners_of_group
      assert User.respond_to? :admins_of_group
      assert User.respond_to? :readers_of_group
      assert User.respond_to? :writers_of_group
      assert User.respond_to? :is_role_in_group?
      assert User.respond_to? :is_member_of?
      assert User.respond_to? :roles_in
      assert User.respond_to? :roleset_in
    end

  end
end
