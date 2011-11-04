require 'test_helper'

class IsUsedPermissively < ActiveSupport::TestCase

  context "module" do
    should "be a module" do
      assert_kind_of Module, ActsPermissive::PermissiveObject
    end
  end

  context "instance methods" do
    setup do
      @thing = Factory :thing
    end

    should "be defined" do
      assert @thing.respond_to? :is_used_permissively?
    end
  end
end