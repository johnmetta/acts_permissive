require File.join(File.dirname(__FILE__), 'spec_helper')

describe ActsPermissive::PermissionMap do

  describe "hash" do
    ActsPermissive::PermissionMap.hash[:read] == 1
    ActsPermissive::PermissionMap.hash[:write] == 2
    ActsPermissive::PermissionMap.hash[:admin] == 4
    ActsPermissive::PermissionMap.hash[:owner] == 8
  end

  describe "permission constants" do
    it "should have a `hash' method" do
      ActsPermissive::PermissionMap.should respond_to(:hash)
    end

    it "should return an ordered hash when `hash' is called" do
      ActsPermissive::PermissionMap.hash.should be_instance_of(ActiveSupport::OrderedHash)
    end

    it "should have symbol keys for the permission constants" do
      ActsPermissive::PermissionMap.hash.has_key?(:admin).should be_true
    end

    it "should convert all CONSTANT values to base-2 compatible integers" do
      ActsPermissive::PermissionMap.constants.each do |constant|
        ActsPermissive::PermissionMap.hash[constant.downcase.to_sym].should == 2 ** ActsPermissive::PermissionMap.const_get(constant)
      end
    end

    it "should explode when a constant isn't Numeric" do
      ActsPermissive::PermissionMap.const_set('FOOBAR', 'achoo')
      lambda {
        ActsPermissive::PermissionMap.hash
      }.should raise_error(ActsPermissive::PermissiveError)

      ActsPermissive::PermissionMap.const_set('FOOBAR', 5)
      lambda {
        ActsPermissive::PermissionMap.hash
      }.should_not raise_error(ActsPermissive::PermissiveError)
    end

    it "Should not allow strings, symbols or floats" do
      raise_exception ActsPermissive::PermissiveError do
        module PermissionMap
          FIRST = 1
          SECOND = :two
        end
      end
      raise_exception ActsPermissive::PermissiveError do
        module PermissionMap
          FIRST = 1
          SECOND = "two"
        end
      end
      raise_exception ActsPermissive::PermissiveError do
        module PermissionMap
          FIRST = 1
          SECOND = 2.2
        end
      end

    end
  end
end
