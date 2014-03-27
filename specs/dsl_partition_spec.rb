require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Partition" do
  it "should be created" do
    Midwife::DSL::Partition.new('/').must_be_instance_of Midwife::DSL::Partition
  end

  it "must respond to path" do
    Midwife::DSL::Partition.new('/').must_respond_to :path
  end

  it "must respond to the size accessors" do
    Midwife::DSL::Partition.new('/').must_respond_to :size
    Midwife::DSL::Partition.new('/').must_respond_to :size=
  end

  it "must respond to the type accessors" do
    Midwife::DSL::Partition.new('/').must_respond_to :type
    Midwife::DSL::Partition.new('/').must_respond_to :type=
  end

  it "must respond to the primary accessors" do
    Midwife::DSL::Partition.new('/').must_respond_to :primary
    Midwife::DSL::Partition.new('/').must_respond_to :primary=
  end

  it "must respond to the grow accessors" do
    Midwife::DSL::Partition.new('/').must_respond_to :grow
    Midwife::DSL::Partition.new('/').must_respond_to :grow=
  end

  it "must respond to the recommended accessors" do
    Midwife::DSL::Partition.new('/').must_respond_to :recommended
    Midwife::DSL::Partition.new('/').must_respond_to :recommended=
  end

  it "must build" do
    part = Midwife::DSL::Partition.build('/') do
      size 100
      type "ext4"
      primary
      grow
      recommended
    end
    part.size.must_equal 100
    part.type.must_equal "ext4"
    part.primary.must_equal true
    part.grow.must_equal true
    part.recommended.must_equal true
  end
end
