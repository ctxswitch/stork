require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Objects::VolumeGroup" do
  it "should be created" do
    Stork::Objects::VolumeGroup.new('/').must_be_instance_of Stork::Objects::VolumeGroup
  end

  it "must respond to name" do
    Stork::Objects::VolumeGroup.new('/').must_respond_to :name
  end

  it "must respond to the partition accessors" do
    Stork::Objects::VolumeGroup.new('/').must_respond_to :partition
    Stork::Objects::VolumeGroup.new('/').must_respond_to :partition=
  end

  it "must build" do
    vg = Stork::Objects::VolumeGroup.build 'vg', part: 'pv.01'
    vg.name.must_equal 'vg'
    vg.partition.must_equal 'pv.01'
    vg.logical_volumes.must_equal []
  end
end
