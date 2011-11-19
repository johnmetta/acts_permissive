require File.join(File.dirname(__FILE__), 'spec_helper')

describe ActsPermissive::PermissiveObject do

  before :each do
    @user = Factory :user
    @admin = Factory :admin
    @thing = Factory :thing
    @widget = Factory :widget
    @circle = @user.build_circle :objects => [@thing]
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

    it "Should be addable to a circle" do
      @widget.add_to @circle
      @circle.items.include?(@widget).should be_true
    end

    it "should be removable from a circle" do
      @thing.remove_from @circle
      @circle.items.include?(@thing).should be_false
    end

  end

end