require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Objects::Partition" do
  it "should be created" do
    Stork::Objects::Partition.new('/').must_be_instance_of Stork::Objects::Partition
  end

  it "must respond to path" do
    Stork::Objects::Partition.new('/').must_respond_to :path
  end

  it "must respond to the size accessors" do
    Stork::Objects::Partition.new('/').must_respond_to :size
    Stork::Objects::Partition.new('/').must_respond_to :size=
  end

  it "must respond to the type accessors" do
    Stork::Objects::Partition.new('/').must_respond_to :type
    Stork::Objects::Partition.new('/').must_respond_to :type=
  end

  it "must respond to the primary accessors" do
    Stork::Objects::Partition.new('/').must_respond_to :primary
    Stork::Objects::Partition.new('/').must_respond_to :primary=
  end

  it "must respond to the grow accessors" do
    Stork::Objects::Partition.new('/').must_respond_to :grow
    Stork::Objects::Partition.new('/').must_respond_to :grow=
  end

  it "must respond to the recommended accessors" do
    Stork::Objects::Partition.new('/').must_respond_to :recommended
    Stork::Objects::Partition.new('/').must_respond_to :recommended=
  end

  it "must build" do
    part = Stork::Objects::Partition.build('/') do
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
