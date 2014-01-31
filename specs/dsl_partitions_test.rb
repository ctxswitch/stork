require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Partitions" do
  before :each do
    @parts = Midwife::DSL::Partitions.new('default')
    @parts.part "/boot" do
      size 100
    end
    @parts.part "/" do
      size 1
      grow
    end

    @partsemit = "part /boot --size 100 --fstype ext4\npart / --size 1 --fstype ext4 --grow\n"
  end

  it "emits the correct kickstart lines with defaults" do
    @parts.emit.must_equal @partsemit
  end

  it "emits with zerombr" do
    @parts.zerombr
    @parts.emit.must_equal "zerombr yes\n#{@partsemit}"
  end

  it "emits with zerombr and clearpart" do
    @parts.zerombr
    @parts.clearpart
    @parts.emit.must_equal "zerombr yes\nclearpart --all --initlabel\n#{@partsemit}"
  end
end