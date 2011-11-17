require File.join(File.dirname(__FILE__), 'spec_helper')

describe ActsPermissive::Circle do

  before :each do
    @user = Factory :user
    @admin = Factory :admin
    @thing = Factory :thing
    @widget = Factory :widget
  end

  describe "class" do
    it "should be buildable by the user" do
      circle = @user.build_circle
      circle.should be_an_instance_of(ActsPermissive::Circle)
      @user.circles.last.should == circle
    end

    it "should be buildable with objects" do
      circle = @admin.build_circle :objects => [@thing, @widget]
      circle.items.should_not be_nil
      circle.items.length.should == 2
      puts circle.items.to_yaml
      circle.items.include?(@thing).should be_true
    end

    it "should have a guid" do
      circle = @user.build_circle
      circle.guid.should be_an_instance_of(String)
    end

    it "should have a name" do
      circle = @admin.build_circle
      circle.name.should_not be_nil
    end

  end

  describe "user circles" do

    it "should have a list of owned circles" do
#      @user.owned_circles.should_not be_nil
    end

  end

end