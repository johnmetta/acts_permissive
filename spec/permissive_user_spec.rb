require File.join(File.dirname(__FILE__), 'spec_helper')

describe ActsPermissive::PermissiveUser do

  describe "loading" do

    before do
      @user = Factory :user
      @admin = Factory :admin
    end

    it "should load into arbitrary user models" do
      @user.is_permissive?.should be_true
      @admin.is_permissive?.should be_true
    end
  end

  describe "circles" do

    before do
      @user = Factory :user
      @admin = Factory :admin
    end

    it "should have a list of circles" do
      @user.circles.should be_an_instance_of Array
    end

  end

  describe "permissions" do
    before do
      @user = Factory :user
      @admin = Factory :admin
    end

    it "should have a list of permissions" do
      @user.permissions.should be_an_instance_of Array
    end
  end

  describe "can methods" do
    before do
      @user = Factory :user
      @admin = Factory :admin
      @widget = Factory :widget
      @admin.build_circle :name => "blah", :objects => [@widget]
    end

    it "should have a good can! method" do
      @admin.circles.last.name.should == "blah"
      perm = @user.can!(:read, :on => @admin.circles.last)
      perm.class.should == ActsPermissive::Permission
      perm.mask.should == 1
      perm.circle.name.should == "blah"
    end
  end
end