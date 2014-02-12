require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::Build::PartitionScheme" do
  before :each do
    @partsemit = "part /boot --size 100 --fstype ext4\npart / --size 1 --fstype ext4 --grow\n"
  end

  it "emits the correct kickstart lines with defaults" do
    parts = Midwife::Build::Scheme.build('default') do
      part "/boot" do
        size 100
      end
      part "/" do
        size 1
        grow
      end
    end
    parts.emit.must_equal @partsemit
  end

  it "emits with zerombr" do
    parts = Midwife::Build::Scheme.build('default') do
      zerombr
      part "/boot" do
        size 100
      end
      part "/" do
        size 1
        grow
      end
    end
    parts.emit.must_equal "zerombr yes\n#{@partsemit}"
  end

  it "emits with zerombr and clearpart" do
    parts = Midwife::Build::Scheme.build('default') do
      zerombr
      clearpart
      part "/boot" do
        size 100
      end
      part "/" do
        size 1
        grow
      end
    end
    parts.emit.must_equal "zerombr yes\nclearpart --all --initlabel\n#{@partsemit}"
  end
end