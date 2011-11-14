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
      Factory(:sam).can_read?(@thing)
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
      assert @thing.respond_to? :is_public?
      assert @thing.respond_to? :circle_of_trust
      assert @thing.respond_to? :make_private!
    end

    should "return the default circle" do
      thing = Factory :thing
      assert thing.circle.name == thing.guid
    end

    should "set private and public correctly" do
      thing = Factory :thing
      assert thing.is_public? == false
      thing.make_public!
      assert thing.is_public?
      thing.make_private!
      assert thing.is_public? == false
    end
  end
end