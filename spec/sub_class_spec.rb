require File.join(File.dirname(__FILE__), 'spec_helper')

describe SubClass do

  before :each do
    @user = Factory :user
    @admin = Factory :admin
    @thing = Factory :thing
    @widget = Factory :widget
  end

  describe "class" do
    it "should be buildable by the user" do
      circle = @user.build_circle :class => SubClass, :name => "blah"
      circle.should be_a_kind_of(ActsPermissive::Circle)
      circle.should be_an_instance_of(SubClass)
      @user.circles.collect{|c| c.name}.should == ["blah"]
    end

    it "should be buildable with objects" do
      circle = @admin.build_circle :class => SubClass, :objects => [@thing, @widget]
      circle.items.should_not be_nil
      circle.items.length.should == 2
      circle.items.collect{|i| i.class.name}.should == ["Thing", "Widget"]
    end

    it "should have a guid" do
      circle = @user.build_circle :class => SubClass
      circle.guid.should be_an_instance_of(String)
    end

    it "should have a name" do
      circle = @admin.build_circle :class => SubClass
      circle.name.should_not be_nil
    end

  end

end