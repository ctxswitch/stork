require File.dirname(__FILE__) + '/spec_helper'
require 'fileutils'

describe "Stork::PXE" do
  before :all do
    @host = collection.hosts.get("server.example.org")
    @path = './specs/tmp/pxeboot'
    FileUtils.mkdir_p @path
    @pxe = Stork::PXE.new(@host, 'midwife.example.org', 9293)
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
        LOCALBOOT 0
    EOS
    File.read("#{@path}/01-00-11-22-33-44-55").must_equal expected_content
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
        LOCALBOOT 0
    EOS
    File.read("#{@path}/01-00-11-22-33-44-55").must_equal expected_content
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
        append initrd=initrd.img ksdevice=bootif priority=critical kssendmac ks=http://midwife.example.org:9293/host/server.example.org
    EOS
    File.read("#{@path}/01-00-11-22-33-44-55").must_equal expected_content
  end
end