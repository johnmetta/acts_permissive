require File.join(File.dirname(__FILE__), 'spec_helper')

describe ActsPermissive::Permission do

  before :each do
    @user = Factory :user
    @admin = Factory :admin
    @thing = Factory :thing
    @widget = Factory :widget
  end

  describe "class" do
    it "Should respond to class methods" do
      ActsPermissive::Permission.respond_to? :on
      ActsPermissive::Permission.respond_to? :for
    end
  end

end
