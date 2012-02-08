require File.join(File.dirname(__FILE__), 'spec_helper')

describe ActsPermissive::PermissiveObject do

  before :all do
    FakeWeb.allow_net_connect = false

    @all_resp = '<datasets type="array">
                  <dataset><id>123</id><name>Blah</name><description>Some stuff</description><creator-id>11111111-1111-1111-1111-111111111111</creator-id></dataset>
                  <dataset><id>321</id><name>Blah</name><description>Some stuff</description><creator-id>11111111-1111-1111-1111-111111111111</creator-id></dataset>
                </datasets>'
    @resp_123 = '<dataset><id>123</id><name>Blah</name><description>Some stuff</description><creator-id>11111111-1111-1111-1111-111111111111</creator-id></dataset>'
    @resp_321 = '<dataset><id>321</id><name>Blah</name><description>Some stuff</description><creator-id>11111111-1111-1111-1111-111111111111</creator-id></dataset>'

    FakeWeb.register_uri(:get, "http://api.sample.com/rest_objects/123.xml", :body => @resp_123, :status => ["200", "OK"])
    FakeWeb.register_uri(:get, "http://api.sample.com/rest_objects/321.xml", :body => @resp_321, :status => ["200", "OK"])
    FakeWeb.register_uri(:get, "http://api.sample.com/rest_objects.xml", :body => @all_resp, :status => ["200", "OK"])

  end

  before :each do
    @user = Factory :user
    @admin = Factory :admin
    @rest_object = RestObject.find(321)
    @circle = @user.build_circle :objects => [@rest_object]
  end

  after :all do
    FakeWeb.allow_net_connect = true
    FakeWeb.clean_registry
  end

  describe "fakeweb" do
    it "should work" do
      rest_object = RestObject.find(123)
      rest_object.should be_valid
      rest_object.id.should eq '123'
    end
  end

  describe "circles" do

    it "should initialize" do
      @rest_object.is_used_permissively?.should be_true
    end

    it "should have circles" do
      @rest_object.should respond_to(:circles)
    end

    it "should have an array of circles" do
      @rest_object.circles.should be_an_instance_of Array
    end

    it "Should be addable to a circle" do
      @circle.items.include?(@rest_object).should be_true
    end

    it "should be removable from a circle" do
      @rest_object.remove_from @circle
      @circle.items.include?(@rest_object).should be_false
    end
  end

  describe "all_who_can" do

    before :each do
      @admin.can!(:admin, :in => @circle)
      @anne = Factory :user
      @debbie = Factory :user
      @anne.can!(:read, :in => @circle)
      @widget = RestObject.find(123)
      @widget.add_to @circle
    end

    it "should correctly scope who_can_see" do
      [@anne, @admin, @user].each do |u|
        ActsPermissive::Grouping.who_can_see(@widget).include?(u).should be_true
      end
      ActsPermissive::Grouping.who_can_see(@widget).include?(@debbie).should be_false
    end

    it "should return a list of users who can perform the given functions" do
      [@user, @anne].each do |u|
        @rest_object.all_who_can(:read).include?(u).should be_true
      end

      [@user, @admin].each do |u|
        @rest_object.all_who_can(:admin).include?(u).should be_true
      end
    end

    it "should not include users who can't perform the function" do
      [@admin, @debbie, @anne].each do |u|
        @rest_object.all_who_can(:write).include?(u).should be_false
      end
    end

    it "Should correctly show all users who can :see an object" do
      [@admin, @anne, @user].each do |u|
        @rest_object.all_who_can(:see).include?(u).should be_true
      end
      @rest_object.all_who_can(:see).include?(@debbie).should be_false
    end

    it "should throw an error when using :see with other permissions" do

    end

  end
end