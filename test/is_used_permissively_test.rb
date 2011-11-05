require 'test_helper'

class IsUsedPermissively < ActiveSupport::TestCase

  context "module" do
    should "be a module" do
      assert_kind_of Module, ActsPermissive::PermissiveObject
    end
  end

  context "construction" do
    setup do
      @thing = Factory :thing
    end

    should "default to public" do
      @thing.is_public?
      Factory(:sam).reads?(@thing)
    end

    should "be valid" do
      @thing.valid?
    end

    should "have a default circle" do
      assert @thing.circle.nil? == false
    end

    should "have the default circles name equal the object guid" do
      assert @thing.circle.name == @thing.guid
    end

    should "have a guid generated" do
      assert @thing.guid.nil? == false
    end
  end

  context "instance methods" do
    setup do
      @thing = Factory :thing
    end

    should "be defined" do
      assert @thing.respond_to? :is_used_permissively?
      assert @thing.respond_to? :add_owner
      assert @thing.respond_to? :is_public?
      assert @thing.respond_to? :remove_owner
      assert @thing.respond_to? :circle_of_trust
      assert @thing.respond_to? :make_private!
      assert @thing.respond_to? :grant
      assert @thing.respond_to? :revoke
      assert @thing.respond_to? :grants
      assert @thing.respond_to? :revokes
      assert @thing.respond_to? :add_owner
      assert @thing.respond_to? :remove_owner
      assert @thing.respond_to? :add_admin
      assert @thing.respond_to? :remove_admin
      assert @thing.respond_to? :add_writer
      assert @thing.respond_to? :remove_writer
      assert @thing.respond_to? :add_reader
      assert @thing.respond_to? :remove_reader
    end

    should "return the default circle" do
      thing = Factory :thing
      assert thing.circle.name == thing.guid
    end

    should "correctly add an owner" do
      @thing = Factory :thing
      user = Factory :john
      user.make_owner_of @thing
      assert user.owns?(@thing) == true
    end

    context "permission booleans" do

      setup do
        @sam = Factory :sam
        @john = Factory :john
        @john.make_owner_of( Factory :thing )
      end
      should "correctly return true if object owner" do
        assert @sam.owns?(@thing) == false
        assert @john.owns?(@thing) == true
      end

    end

  end
end