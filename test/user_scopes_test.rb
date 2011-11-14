require 'test_helper'

class UserScopesTest < ActiveSupport::TestCase

  context "module" do
    should "be a proper class" do
      assert_kind_of Module, ActsPermisive::UserScopes
    end
  end

  context "scopes" do
    should "return all owners of an object"
    should "return all admins of an object"
    should "return all writers of an object"
    should "return all readers of an object"
  end

end