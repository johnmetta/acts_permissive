require File.join(File.dirname(__FILE__), 'spec_helper')

describe ActsPermissive::PermissiveObject do

  before :each do
    @user = Factory :user
    @admin = Factory :admin
    @thing = Factory :thing
    @widget = Factory :widget
  end

  describe "class" do

    it "should initialize" do
      @thing.is_used_permissively?.should be_true
      @widget.is_used_permissively?.should be_true
    end

    it "should have circles" do
      @thing.should respond_to(:circles)
    end

    it "should have an array of circles" do
      @widget.circles.should be_an_instance_of Array
    end

  end

end