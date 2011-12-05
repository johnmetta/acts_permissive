require File.join(File.dirname(__FILE__), 'spec_helper')

describe ActsPermissive do
  before :each do
    @user = Factory :user
    @admin = Factory :admin
    @widget = Factory :widget
    @widget2 = Factory :widget
    @thing = Factory :thing
    @admin_circle = @admin.build_circle :name => "blah", :objects => [@widget, @widget2]
    @user_circle = @user.build_circle :name => "yada", :objects => [@thing], :mask => 31

    @new_user = Factory :user, :name => "@@@@@@@@@@@@@@@"
    @new_user.can!(:read, :in => @admin_circle)
    @new_user.can?(:read, :in => @admin_circle).should be_true
  end

  it "should be valid" do
    ActsPermissive.should be_a(Module)
  end

  it "Should return proper circling membership for things" do
    ActsPermissive::Circling.items_in(@admin_circle).should == [@widget, @widget2]
    ActsPermissive::Circling.items_in(@user_circle).should == [@thing]
    @widget2.add_to @user_circle
    ActsPermissive::Circling.items_in(@user_circle).should == [@thing, @widget2]
  end

  it "Should return proper circling membership for users" do
    ActsPermissive::Circling.users_in(@admin_circle).should == [@admin, @new_user]
    ActsPermissive::Circling.users_in(@user_circle).should == [@user]
  end
end