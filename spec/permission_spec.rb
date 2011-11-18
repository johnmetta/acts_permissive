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

    it "should return the correct permissions" do
      ActsPermissive::Permission.bit_for(:admin).should == 4
      ActsPermissive::Permission.bit_for(:Owner).should == 8
    end
  end

end
