require File.join(File.dirname(__FILE__), 'spec_helper')

describe Circle do

  before :each do
    @user = Factory :user
    @admin = Factory :admin
    @thing = Factory :thing
    @widget = Factory :widget
  end

  describe "class" do
    it "should be buildable by the user" do
      circle = @user.build_circle
      circle.should be_an_instance_of(Circle)
      @user.circles.last.should be(circle)
    end

    it "should be buildable with objects" do
      circle = @admin.build_circle [@thing, @widget]
      circle.items.should_not be_nil
      circle.items.length == 2
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