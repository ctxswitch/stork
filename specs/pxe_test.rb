require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::PXE" do
  before :all do
    host = Midwife::DSL::Host.build "test" do
      pxemac "00:11:22:33:44:56"
    end
    @pxe = Midwife::PXE.new(host)
  end

  it "creates the localboot file" do
    # @pxe.localboot
    # File.exists?("/path/to/pxefile").must_equal true
    #.must_equal File.read("specs/files/results/localboot.pxe")
  end

  it "creates the default file" do
    # @pxe.default
    # File.exists?("/path/to/pxefile").must_equal true
    #.must_equal File.read("specs/files/results/localboot.pxe")
  end

  it "creates the install file" do
    # @pxe.install
    # File.exists?("/path/to/pxefile").must_equal true
    #.must_equal File.read("specs/files/results/install.pxe")
  end
end