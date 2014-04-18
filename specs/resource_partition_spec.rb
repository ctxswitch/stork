require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Resource::Partition" do
  it "should be created" do
    Stork::Resource::Partition.new('/').must_be_instance_of Stork::Resource::Partition
  end

  it "must respond to path" do
    Stork::Resource::Partition.new('/').must_respond_to :path
  end

  it "must respond to the size accessors" do
    Stork::Resource::Partition.new('/').must_respond_to :size
    Stork::Resource::Partition.new('/').must_respond_to :size=
  end

  it "must respond to the type accessors" do
    Stork::Resource::Partition.new('/').must_respond_to :type
    Stork::Resource::Partition.new('/').must_respond_to :type=
  end

  it "must respond to the primary accessors" do
    Stork::Resource::Partition.new('/').must_respond_to :primary
    Stork::Resource::Partition.new('/').must_respond_to :primary=
  end

  it "must respond to the grow accessors" do
    Stork::Resource::Partition.new('/').must_respond_to :grow
    Stork::Resource::Partition.new('/').must_respond_to :grow=
  end

  it "must respond to the recommended accessors" do
    Stork::Resource::Partition.new('/').must_respond_to :recommended
    Stork::Resource::Partition.new('/').must_respond_to :recommended=
  end

  it "must build" do
    part = Stork::Resource::Partition.build('/') do
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
