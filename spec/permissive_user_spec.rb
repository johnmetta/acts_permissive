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
end