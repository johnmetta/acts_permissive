require 'test_helper'

class IsUsedPermissively < ActiveSupport::TestCase

  def setup
    ActsPermissive::Role.create(:name => "owner", :power => '1000')
    ActsPermissive::Role.create(:name => "admin", :power => '0100')
    ActsPermissive::Role.create(:name => "write", :power => '0010')
    ActsPermissive::Role.create(:name => "read",  :power => '0001')
  end
  def teardown
    ActsPermissive::Role.owner.destroy
    ActsPermissive::Role.admin.destroy
    ActsPermissive::Role.write.destroy
    ActsPermissive::Role.read.destroy
  end

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
      assert @thing.respond_to? :is_public?
      assert @thing.respond_to? :circle_of_trust
      assert @thing.respond_to? :make_private!
    end

    should "return the default circle" do
      thing = Factory :thing
      assert thing.circle.name == thing.guid
    end

    should "correctly add an owner" do
      thing = Factory :thing
      user = Factory :john
      user.make_owner_of thing
      assert user.owns?(thing)
    end

  end
end