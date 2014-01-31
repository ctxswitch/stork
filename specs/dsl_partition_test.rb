require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Partition" do
  before :each do
    @part = Midwife::DSL::Partition.new('/')
  end

  it "emits the correct kickstart lines with defaults" do
    @part.emit.must_equal "part / --recommended --fstype ext4"
  end

  it "emits with size and grow" do
    @part.grow
    @part.size 1
    @part.emit.must_equal "part / --size 1 --fstype ext4 --grow"
  end

  it "emits with asprimary" do
    @part.primary
    @part.emit.must_equal "part / --recommended --fstype ext4 --asprimary"
  end
end