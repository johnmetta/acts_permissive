require File.join(File.dirname(__FILE__), 'spec_helper')

describe ActsPermissive::Permission do

  before :each do
    @user = Factory :user
    @admin = Factory :admin
    @widget = Factory :widget
    @thing = Factory :thing

    @admin_circle = @admin.build_circle :name => "blah", :objects => [@widget]
    @user_circle = @user.build_circle :name => "yada", :objects => [@thing], :mask => 31

    @user.can!(:read, :write, :in => @admin_circle)
    @admin.can!(:read, :write, :admin, :in => @user_circle)

    @new_user = Factory :user
    @new_user.can!(:read, :in => @user_circle)
    @new_user.can!(:write, :in => @admin_circle)
  end

  describe "class" do
    it "Should respond to class methods" do
      ActsPermissive::Permission.respond_to? :in
      ActsPermissive::Permission.respond_to? :for
    end

    it "should return the correct permissions" do
      ActsPermissive::Permission.bit_for(:admin).should == 8
      ActsPermissive::Permission.bit_for(:Owner).should == 16
    end
  end

  describe "scopes" do

    it "should correctly query using the :in scope" do
      ActsPermissive::Permission.in(@user_circle).count.should == 3
      ActsPermissive::Permission.in(@admin_circle).count.should == 3
    end
    it "should correctly query using the :for scope" do
      ActsPermissive::Permission.for(@user).count.should == 2
      ActsPermissive::Permission.for(@admin).count.should == 2
      ActsPermissive::Permission.for(@new_user).count.should == 2
    end

    it "should return a list of users given a permission mask"
  end

end
