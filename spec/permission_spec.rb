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
      ActsPermissive::Permission.respond_to? :in
      ActsPermissive::Permission.respond_to? :for
    end

    it "should return the correct permissions" do
      ActsPermissive::Permission.bit_for(:admin).should == 8
      ActsPermissive::Permission.bit_for(:Owner).should == 16
    end
  end

  describe "scopes" do
    it "should correctly query using the :in scope"
    it "should correctly query using the :for scope"
  end

end
