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
      circle = @user.build_circle :name => "blah"
      circle.should be_an_instance_of(ActsPermissive::Circle)
      @user.circles.collect{|c| c.name}.should == ["blah"]
    end

    it "should be buildable with objects" do
      circle = @admin.build_circle :objects => [@thing, @widget]
      circle.items.should_not be_nil
      circle.items.length.should == 2
      circle.items.collect{|i| i.class.name}.should == ["Thing", "Widget"]
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

  describe "query methods" do

    before :each do
      @another_thing = Factory :thing
      @another_widget = Factory :widget
      @uc = @user.build_circle :name => "blah", :objects => [@thing, @another_thing]
      @ac = @admin.build_circle :name => "yada", :objects => [@widget, @another_widget, @thing]
    end

    it "should return the list of items in a circle" do
      @uc.items.should == [@thing, @another_thing]
      @ac.items.should == [@widget, @another_widget, @thing]
    end

    it "should return the list of users in a circle" do
      anne = Factory :user
      debbie = Factory :user
      frank = Factory :user
      anne.can!(:read, :in => @uc)
      debbie.can!(:read, :write, :in => @uc)
      frank.can!(:read, :in => @ac)

      [@user, anne, debbie].each do |u|
        @uc.users.include?(u).should be_true
      end

      [@admin, frank].each do |u|
        @ac.users.include?(u).should be_true
      end

      [@user, anne, debbie].each do |u|
        @ac.users.include?(u).should_not be_true
      end

    end

  end

  describe "scopes" do
    before :each do
      @user = Factory :user
      @circles = []
      %w{one two three four five blah yada}.each do |w|
        @circles << @user.build_circle( :name => w)
      end

    end

    it "should return a list of users" do
      another_user = Factory :user
      another_user.can!(:read, :in => @circles.first)
      @circles.first.users.include?(@user).should be_true
      @circles.first.users.include?(another_user).should be_true
    end

    it "should return a list of the user-like class' circles" do
      @user.circles.should have(7).items
      @circles.each do |c|
        @user.circles.include?(c).should be_true
      end
    end

    it "should return a list of all circles for a given user" do
      # Look both ways.
      ActsPermissive::Circle.by_user(@user).should =~ @circles
    end
  end
end