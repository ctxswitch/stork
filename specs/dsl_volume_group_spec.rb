require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::VolumeGroup" do
  it "should be created" do
    Midwife::DSL::VolumeGroup.new('/').must_be_instance_of Midwife::DSL::VolumeGroup
  end

  it "must respond to name" do
    Midwife::DSL::VolumeGroup.new('/').must_respond_to :name
  end

  it "must respond to the partition accessors" do
    Midwife::DSL::VolumeGroup.new('/').must_respond_to :partition
    Midwife::DSL::VolumeGroup.new('/').must_respond_to :partition=
  end

  it "must build" do
    vg = Midwife::DSL::VolumeGroup.build 'vg', part: 'pv.01'
    vg.name.must_equal 'vg'
    vg.partition.must_equal 'pv.01'
    vg.logical_volumes.must_equal []
  end
end
