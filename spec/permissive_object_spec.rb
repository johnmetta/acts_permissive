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

  describe "all_who_can" do

    before :each do
      @admin.can!(:admin, :in => @circle)
      @anne = Factory :user
      @debbie = Factory :user
      @anne.can!(:read, :in => @circle)
    end

    it "should return a list of users who can perform the given functions" do
      [@user, @anne].each do |u|
        @thing.all_who_can(:read).include?(u).should be_true
      end

      [@user, @admin].each do |u|
        @thing.all_who_can(:admin).include?(u).should be_true
      end
    end

    it "should not include users who can't perform the function" do

      [@admin, @debbie, @anne].each do |u|
        @thing.all_who_can(:write).include?(u).should be_false
      end
    end

    it "Should correctly show all users who can :see an object" do
      [@admin, @anne, @user].each do |u|
        @thing.all_who_can(:see).include?(u).should be_true
      end
      @thing.all_who_can(:see).include?(@debbie).should be_false
    end

  end

end