require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::Build::Partition" do
  it "emits the correct kickstart lines with defaults" do
    part = Midwife::Build::Partition.build('/')
    part.emit.must_equal "part / --recommended --fstype ext4"
  end

  it "emits with size and grow" do
    part = Midwife::Build::Partition.build('/') do
      grow
      size 1
    end
    part.emit.must_equal "part / --size 1 --fstype ext4 --grow"
  end

  it "emits with asprimary" do
    part = Midwife::Build::Partition.build('/') do
      primary
    end
    part.emit.must_equal "part / --recommended --fstype ext4 --asprimary"
  end
end