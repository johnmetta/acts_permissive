require 'test_helper'

class MembershipContainerTest < ActiveSupport::TestCase

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
      @user = Factory :sam
      @container = @user.grants
    end

    should "Set the correct values" do
      assert @container.to(@user) == @container
      assert @container.user == @user
      assert @container.valid? == false
    end
  end

  context "circle methods" do

    setup do
      @thing = Factory :thing
      @john = Factory :john
      @john.make_owner_of @thing
    end

    should "Set the correct value" do
      container = @john.grants.on(@thing)
      assert_instance_of ActsPermissive::MembershipContainer, container
      assert container.circle == @thing.circle
      assert container.valid? == false
    end
  end

  context "partial chain" do

    should "Not create membership for only role and user" do
      sam = Factory :sam
      bob = Factory :bob
      container = sam.grants.read.to(bob)
      assert container != true
      assert_instance_of ActsPermissive::MembershipContainer, container
    end

    should "Not create membership for only user and circle" do
      container = ActsPermissive::MembershipContainer.new
      user = Factory :sam
      circle = ActsPermissive::Circle.new
      assert container.on(circle).to(user) == container
    end

  end

  context "full chain" do

    should "Create a full membership with a full chain" do
      sam = Factory :sam
      john = Factory :john
      thing = Factory :thing
      john.make_owner_of thing
      result = john.grants.read.on(thing).to(sam)
      assert sam.reads?(thing)
    end

  end

end