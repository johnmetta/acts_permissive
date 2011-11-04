require 'test_helper'

class ActsPermissiveTest < ActiveSupport::TestCase
  test "ActsPermissive is module" do
    assert_kind_of Module, ActsPermissive
  end

  test "PermissiveGroup is module" do
    assert_kind_of Module, ActsPermissive::PermissiveCircle
  end

  test "PermissiveUser is module" do
    assert_kind_of Module, ActsPermissive::PermissiveUser
  end

  def test_a_users_is_permissive_method_should_be_yes
    user = User.create :name => "blah"
    assert_equal "Yes", user.is_permissive?
  end

end
