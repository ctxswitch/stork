require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::LogicalVolume" do
  it "should be created" do
    Midwife::DSL::LogicalVolume.new('/').must_be_instance_of Midwife::DSL::LogicalVolume
  end

  it "must respond to path" do
    Midwife::DSL::LogicalVolume.new('/').must_respond_to :path
  end

  it "must respond to the size accessors" do
    Midwife::DSL::LogicalVolume.new('/').must_respond_to :size
    Midwife::DSL::LogicalVolume.new('/').must_respond_to :size=
  end

  it "must respond to the type accessors" do
    Midwife::DSL::LogicalVolume.new('/').must_respond_to :type
    Midwife::DSL::LogicalVolume.new('/').must_respond_to :type=
  end

  it "must respond to the grow accessors" do
    Midwife::DSL::LogicalVolume.new('/').must_respond_to :grow
    Midwife::DSL::LogicalVolume.new('/').must_respond_to :grow=
  end

  it "must respond to the recommended accessors" do
    Midwife::DSL::LogicalVolume.new('/').must_respond_to :recommended
    Midwife::DSL::LogicalVolume.new('/').must_respond_to :recommended=
  end

  it "must build" do
    lv = Midwife::DSL::LogicalVolume.build('/') do
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
