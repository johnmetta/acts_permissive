require 'test_helper'

class MembershipContainerTest < ActiveSupport::TestCase

  context "role methods" do
    setup do
      @container = ActsPermissive::MembershipContainer.new
    end

  end
end