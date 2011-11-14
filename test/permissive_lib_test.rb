require 'test_helper'

class LibTestExtended
  extend ActsPermissive::PermissiveLib
end

class LibTestIncluded
  include ActsPermissive::PermissiveLib
end

class PermissiveLibTest < ActiveSupport::TestCase

  context "module" do
    should "load the PermissiveLib module" do
      assert_kind_of Class, LibTestExtended
      assert_kind_of Class, LibTestIncluded
      assert_kind_of Module, ActsPermissive::PermissiveLib
    end

    should "Load an instance of the test class" do
      @libtestextended = LibTestExtended.new
      assert_instance_of LibTestExtended, @libtestextended
      @libtestincluded = LibTestIncluded.new
      assert_instance_of LibTestIncluded, @libtestincluded
    end
  end

  context "instance" do
    setup do
      @libtestincluded = LibTestIncluded.new
    end
    should "give methods to containing instance" do
      assert @libtestincluded.respond_to? :binary_owner
      assert @libtestincluded.respond_to? :binary_admin
      assert @libtestincluded.respond_to? :binary_write
      assert @libtestincluded.respond_to? :binary_read
      assert @libtestincluded.respond_to? :as_integer
      assert @libtestincluded.respond_to? :as_binary
    end

    should "return the correct permission strings" do
      assert @libtestincluded.binary_owner == "100000000"
      assert @libtestincluded.binary_admin == "010000000"
      assert @libtestincluded.binary_write == "001000000"
      assert @libtestincluded.binary_read  == "000100000"
    end

    should "return the correct value as a binary string" do
      assert @libtestincluded.as_binary(1) == "000000001"
      assert @libtestincluded.as_binary(16) == "000010000"
      assert @libtestincluded.as_binary(42) == "000101010"
    end

    should "return the correct integer from a string" do
      assert @libtestincluded.as_integer("101") == 5
      assert @libtestincluded.as_integer("110111") == 55
    end
  end

  context "instance" do
    should "give methods to containing instance" do
      assert LibTestExtended.respond_to? :binary_owner
      assert LibTestExtended.respond_to? :binary_admin
      assert LibTestExtended.respond_to? :binary_write
      assert LibTestExtended.respond_to? :binary_read
      assert LibTestExtended.respond_to? :as_integer
      assert LibTestExtended.respond_to? :as_binary
    end

    should "return the correct permission strings" do
      assert LibTestExtended.binary_owner == "11111111"
      assert LibTestExtended.binary_admin == "01111111"
      assert LibTestExtended.binary_write == "00100000"
      assert LibTestExtended.binary_read ==  "00010000"
    end

    should "return the correct value as a binary string" do
      assert LibTestExtended.as_binary(1) ==  "00000001"
      assert LibTestExtended.as_binary(16) == "00010000"
      assert LibTestExtended.as_binary(42) == "00101010"
    end

    should "return the correct integer from a string" do
      assert LibTestExtended.as_integer("101") == 5
      assert LibTestExtended.as_integer("110111") == 55
    end
  end
end