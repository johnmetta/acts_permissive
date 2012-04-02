require File.join(File.dirname(__FILE__), 'spec_helper')

describe ActsPermissive::PermissiveUser do

  before :each do
    @user = FactoryGirl.create :user
    @admin = FactoryGirl.create :admin
    @widget = FactoryGirl.create :widget
    @thing = FactoryGirl.create :thing
    @admin_circle = @admin.build_circle :name => "blah", :objects => [@widget]
    @user_circle = @user.build_circle :name => "yada", :objects => [@thing], :mask => 31
  end

  describe "loading" do
    it "should load into arbitrary user models" do
      @user.acts_permissive?.should be_true
      @admin.acts_permissive?.should be_true
    end

    it "should return permissible classes with who_can_see" do
      ActsPermissive::Grouping.who_can_see(@thing).should be_an_instance_of(Array)

      ActsPermissive::Grouping.who_can_see(@thing).include?(@user).should be_true
      ActsPermissive::Grouping.who_can_see(@widget).include?(@user).should be_false

      ActsPermissive::Grouping.who_can_see(@thing).include?(@admin).should be_false
      ActsPermissive::Grouping.who_can_see(@widget).include?(@admin).should be_true
    end
  end

  describe "circles" do
    it "should have a list of circles it owns" do
      @user.circles.should have(1).item
    end

    it "should have a list of all circles it has permissions for" do
      @user.can!(:read, :in => @admin_circle)
      @user.circles.include?(@admin_circle).should be_true
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
      @perm = @user.can!(:write, :in => @admin_circle)
      @user.can?(:read, :in => @admin_circle).should be_false
      @user.can?(:write, :in => @admin_circle).should be_true
      @admin.can?(:admin, :in => @admin_circle).should be_true
      @admin.can?(:see => @user_circle).should be_false
    end

    it "should correctly see objects" do
      @admin.can?(:see => @user_circle).should be_false
      @admin.can?(:see => @admin_circle).should be_true
      @user.can?(:see => @user_circle).should be_true
      @user.can?(:see => @admin_circle).should be_false
    end

    it "should return false for a user without permissions" do
      new_user = FactoryGirl.create :user
      new_user.can?(:see => @user_circle).should be_false
      new_user.can?(:read, :in => @user_circle).should be_false
    end

    describe "can methods on objects instead of circles" do

      it "should allow using the can? method on a model" do
        new_user = FactoryGirl.create :user
        new_user.can!(:read, :in => @admin_circle)
        new_user.can?(:read, @admin_circle.items.first).should be_true
        @admin_circle.items.each{|i| new_user.can?(:read, i).should be_true}
        @admin_circle.items.each{|i| new_user.can?(:write, i).should be_false}
      end

      it "should allow using the can? method on a model" do
        new_user = FactoryGirl.create :user
        new_user.can?(:write, @user_circle.items.first).should be_false

        @user_circle.items.each{|i| new_user.can?(:read, i).should be_false}
        @user_circle.items.each{|i| new_user.can?(:write, i).should be_false}
      end
    end

  end

  describe "permissions methods" do
    it "should return the proper permission map for a circle" do
      @admin.permissions_in(@admin_circle).mask & 16 == 16
      @admin.permissions_in(@admin_circle).mask.should == 255
      @user.permissions_in(@user_circle).mask.should == 31
    end

    it "should allow resetting of permissions" do
      @user.can!(:admin, :read, :in => @admin_circle)
      @user.permissions_in(@admin_circle).mask.should == 10
      @user.reset_permissions!(:in => @admin_circle)
      @user.permissions_in(@admin_circle).mask.should == 0
    end

    it "should ignore resetting if user has no permissions in the circle" do
      @user.reset_permissions!(:in => @admin_circle).should be_nil
    end

  end

  describe "revoking permissions" do
    it "should correctly revoke permissions" do
      @user.can!(:read, :write, :admin, :in => @admin_circle)
      @admin.can!(:read, :write, :in => @user_circle)
      @admin.can?(:read, :write, :in => @user_circle).should be_true
      @user.can?(:read, :write, :admin, :in => @admin_circle).should be_true

      @user.revoke!(:write, :admin, :in => @admin_circle)
      @admin.revoke!(:write, :in => @user_circle)
      @admin.can?(:write, :in => @user_circle).should be_false
      @user.can?(:read, :in => @admin_circle).should be_true
      @user.can?(:write, :in => @admin_circle).should be_false
      @user.can?(:admin, :in => @admin_circle).should be_false

      @user.revoke!(:all, :in => @admin_circle)
      [:read, :write, :see, :admin, :owner].each do |p|
        @user.can?(p, :in => @admin_circle).should be_false
      end
    end
  end

  describe "query methods" do

    it "should return all permissions for a given object" do
      @admin.permissions_for(@thing).should have(0).items

      @admin.can!(:read, :in => @user_circle)
      @admin.permissions_for(@thing).should have(1).item

      another_circle = @user.build_circle :name => "blah", :objects => [@thing]
      @admin.can!(:write, :in => another_circle)
      @admin.permissions_for(@thing).should have(2).items

      @admin.permissions_for(@widget).should have(1).item
      @user.permissions_for(@widget).should have(0).items

      @user.permissions_for(@thing).first.mask.should == 31

    end

  end

end