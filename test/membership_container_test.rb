require 'test_helper'

class MembershipContainerTest < ActiveSupport::TestCase

  context "module" do
    should "be a proper class" do
      assert_kind_of Class, MembershipContainer
    end

    should "respond to permissivelib methods" do
      mc = MembershipContainer.new

      assert mc.respond_to? :binary_owner
      assert mc.respond_to? :binary_admin
      assert mc.respond_to? :binary_write
      assert mc.respond_to? :binary_read
      assert mc.respond_to? :as_integer
      assert mc.respond_to? :as_binary
    end
  end

  context "power methods" do
    setup do
      @john = Factory :john
      @container = @john.grants
    end

    should "return self with ownership power" do
      new = @container.owner
      assert @container == new
      assert new.power == Membership.binary_owner
    end
    should "return self with admin power" do
      new = @container.admin
      assert @container == new
      assert new.power == Membership.binary_admin
    end
    should "return self with ownership power" do
      new = @container.write
      assert @container == new
      assert new.power == Membership.binary_write
    end
    should "return self with ownership power" do
      new = @container.read
      assert @container == new
      assert new.power == Membership.binary_read
    end

  end

  context "user method" do
    setup do
      @john = Factory :john
    end

    should "correctly set the calling user and user" do
      bob = Factory :bob
      cont = @john.grants.to(bob)
      assert cont.calling_user == @john
      assert cont.user == bob
      assert_instance_of MembershipContainer, cont
    end

  end

  context "circle methods" do
    setup do
      @thing = Factory :thing
      @john = Factory :john
      @john.make_owner_of @thing
    end

    should "correctly set the calling user and user" do
      bob = Factory :bob
      cont = @john.grants.on(@thing)
      assert cont.calling_user == @john
      assert cont.circle == @thing.circle
      assert_instance_of MembershipContainer, cont
    end

  end

  context "full membership" do
    setup do
      @thing = Factory :thing
      @john = Factory :john
      @bob = Factory :bob
      @sam = Factory :sam
      @john.make_owner_of @thing
    end

    should "return a full membership" do

      @john.grants.admin.to(@sam).on(@thing)
      assert @sam.can_admin?(@thing)

      @sam.grants.read.to(@bob).on(@thing)
      assert @bob.can_write?(@thing) == false
      assert @bob.can_read?(@thing)
    end

    should "not allow setting of permissions without proper authority" do
      assert_raises ActsPermissive::PermissiveException do
        @sam.grants.admin.on(@thing)
      end
      assert_raises ActsPermissive::PermissiveException do
        @bob.grants.read.on(@thing)
      end
      assert_raise ActsPermissive::PermissiveException do
        @bob.grants.write.on(@thing)
      end
    end
  end
end