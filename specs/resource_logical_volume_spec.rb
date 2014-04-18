require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Resource::LogicalVolume" do
  it "should be created" do
    Stork::Resource::LogicalVolume.new('/').must_be_instance_of Stork::Resource::LogicalVolume
  end

  it "must respond to path" do
    Stork::Resource::LogicalVolume.new('/').must_respond_to :path
  end

  it "must respond to the size accessors" do
    Stork::Resource::LogicalVolume.new('/').must_respond_to :size
    Stork::Resource::LogicalVolume.new('/').must_respond_to :size=
  end

  it "must respond to the type accessors" do
    Stork::Resource::LogicalVolume.new('/').must_respond_to :type
    Stork::Resource::LogicalVolume.new('/').must_respond_to :type=
  end

  it "must respond to the grow accessors" do
    Stork::Resource::LogicalVolume.new('/').must_respond_to :grow
    Stork::Resource::LogicalVolume.new('/').must_respond_to :grow=
  end

  it "must respond to the recommended accessors" do
    Stork::Resource::LogicalVolume.new('/').must_respond_to :recommended
    Stork::Resource::LogicalVolume.new('/').must_respond_to :recommended=
  end

  it "must build" do
    lv = Stork::Resource::LogicalVolume.build('/') do
      size 100
      type "ext4"
      grow
      recommended
    end
    lv.size.must_equal 100
    lv.type.must_equal "ext4"
    lv.grow.must_equal true
    lv.recommended.must_equal true
  end
end
