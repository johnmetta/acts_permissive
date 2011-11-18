require File.join(File.dirname(__FILE__), 'spec_helper')

describe ActsPermissive::PermissiveUser do

  before :each do
    @user = Factory :user
    @admin = Factory :admin
    @widget = Factory :widget
    @thing = Factory :thing
    @admin_circle = @admin.build_circle :name => "blah", :objects => [@widget]
    @user_circle = @user.build_circle :name => "yada", :objects => [@thing], :mask => 31
  end

  describe "loading" do
    it "should load into arbitrary user models" do
      @user.is_permissive?.should be_true
      @admin.is_permissive?.should be_true
    end
  end

  describe "circles" do
    it "should have a list of circles" do
      @user.circles.should be_an_instance_of Array
    end
  end

  describe "permissions" do
    it "should have a list of permissions" do
      @user.permissions.should be_an_instance_of Array
    end
  end

  describe "can methods" do

    it "should have a good can! method" do
      perm = @user.can!(:read, :in => @admin_circle)
      perm.should be_an_instance_of(ActsPermissive::Permission)
      perm.mask.should == 2
      perm.circle.name.should == "blah"
    end

    it "should have a can! method that can handle multiple permissions" do
      perm = @user.can!(:read, :write, :in => @admin_circle)
      perm.should be_an_instance_of(ActsPermissive::Permission)
      perm.mask.should == 6
      perm.circle.name.should == "blah"
    end

    it "should return a boolean for the correct permissions" do
      @user.can!(:write, :in => @admin_circle)
      @user.can?(:read, :in => @admin_circle).should be_false
      @user.can?(:write, :in => @admin_circle).should be_true
      @admin.can?(:admin, :in => @admin_circle).should be_true
      @admin.can?(:see => @user_circle).should be_false
    end
  end

  describe "permissions methods" do
    it "should return the proper permission map for a circle" do
      @admin.permissions_in(@admin_circle).mask & 16 == 16
      @admin.permissions_in(@admin_circle).mask.should == 255
      @user.permissions_in(@user_circle).mask.should == 31
    end

  end
end