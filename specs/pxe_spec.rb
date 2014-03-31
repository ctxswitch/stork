require File.dirname(__FILE__) + '/spec_helper'
require 'fileutils'

describe "Midwife::PXE" do
  before :all do
    @path = File.dirname(__FILE__) + '/tmp/pxeboot'
    FileUtils.mkdir_p @path
    @pxe = Midwife::PXE.new('midwife.example.org', @path, 'example.org', '00:11:22:33:44:55', 'vmlinuz', 'initrd.img')
  end

  after :each do
    Dir.glob("#{@path}/*") { |file| File.unlink(file) }
  end

  it "creates the localboot file" do
    @pxe.localboot
    File.exists?("#{@path}/00-11-22-33-44-55").must_equal true
    File.read("#{@path}/00-11-22-33-44-55").must_equal File.read("specs/files/results/pxe.localboot")
  end

  it "creates the default file" do
    @pxe.default
    File.exists?("#{@path}/00-11-22-33-44-55").must_equal true
    File.read("#{@path}/00-11-22-33-44-55").must_equal File.read("specs/files/results/pxe.localboot")
  end

  it "creates the install file" do
    @pxe.install
    File.exists?("#{@path}/00-11-22-33-44-55").must_equal true
    File.read("#{@path}/00-11-22-33-44-55").must_equal File.read("specs/files/results/pxe.install")
  end
end
