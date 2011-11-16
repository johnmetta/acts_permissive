require File.join(File.dirname(__FILE__), 'spec_helper')

describe Permission do

  before :each do
    @user = Factory :user
    @admin = Factory :admin
    @thing = Factory :thing
    @widget = Factory :widget
  end

  describe "class" do
    it "Should respond to class methods" do
      Permission.respond_to? :on
      Permission.respond_to? :for
    end
  end

end
