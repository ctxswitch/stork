require File.dirname(__FILE__) + '/spec_helper'
require 'fileutils'

describe "Stork::PXE" do
  before :all do
    @path = './specs/tmp/pxeboot'
    FileUtils.mkdir_p @path
    @pxe = Stork::PXE.new(
      'midwife.example.org',
      @path,
      'server.example.org',
      '00:11:22:33:44:55',
      'vmlinuz',
      'initrd.img')
  end

  after(:each) do
    FileUtils.rm_rf(Dir.glob('./specs/tmp/*'))
  end

  it "creates the localboot file" do
    @pxe.localboot
    expected_content = <<-EOS
DEFAULT local
PROMPT 0
TIMEOUT 0
TOTALTIMEOUT 0
ONTIMEOUT local
LABEL local
        LOCALBOOT -1
    EOS
    File.read("#{@path}/00-11-22-33-44-55").must_equal expected_content
  end

  it "creates the default file" do
    @pxe.default
    expected_content = <<-EOS
DEFAULT local
PROMPT 0
TIMEOUT 0
TOTALTIMEOUT 0
ONTIMEOUT local
LABEL local
        LOCALBOOT -1
    EOS
    File.read("#{@path}/00-11-22-33-44-55").must_equal expected_content
  end

  it "creates the install file" do
    @pxe.install
    expected_content = <<-EOS
default install
prompt 0
timeout 1
label install
        kernel vmlinuz
        ipappend 2
        append initrd=initrd.img ksdevice=bootif priority=critical kssendmac ks=http://midwife.example.org/ks/server.example.org
    EOS
    File.read("#{@path}/00-11-22-33-44-55").must_equal expected_content
  end
end