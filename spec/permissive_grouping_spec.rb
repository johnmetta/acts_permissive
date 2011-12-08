require File.join(File.dirname(__FILE__), 'spec_helper')

describe ActsPermissive::Grouping do

  before :each do
    @user = Factory :user
    @admin = Factory :admin
    @widget = Factory :widget
    @thing = Factory :thing
    @admin_circle = @admin.build_circle :name => "blah", :objects => [@widget]
    @user_circle = @user.build_circle :name => "yada", :objects => [@thing], :mask => 31
  end

  describe "scopes" do

    it "should return groupings by circle" do
      ActsPermissive::Grouping.by_circle(@admin_circle).should have(1).item
      @user.can!(:read, :in => @admin_circle)
      @user.can?(:read, :in => @admin_circle).should be_true
      ActsPermissive::Grouping.by_circle(@admin_circle).should have(2).items
    end

    it "should return groupings by object" do
      ActsPermissive::Grouping.by_object(@thing).should have(1).item
      @admin.can!(:read, :in => @user_circle)
      @admin.can?(:read, :in => @user_circle).should be_true
      # Should now have a grouping for @thing
      ActsPermissive::Grouping.by_object(@thing).should have(2).items
      # but should not have a grouping for @widget
      ActsPermissive::Grouping.by_object(@widget).should have(1).items

      %w{one two three}.each do |o|
        Factory(:user).can!(:read, :in => @user_circle)
      end
      ActsPermissive::Grouping.by_object(@thing).should have(5).items
      end
  end
end