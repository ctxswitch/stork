require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Domain" do
  before :each do
    @domain = Midwife::DSL::Domain.new('test')
  end

  it "emits the correct kickstart lines with defaults" do
    @domain.emit.must_equal ""
  end

  it "emits with the rest" do
    @domain.netmask "255.255.255.0"
    @domain.gateway "192.168.0.1"
    @domain.nameserver "192.168.0.1"
    @domain.emit.must_equal "--netmask=255.255.255.0 --gateway=192.168.0.1 --nameserver=192.168.0.1"
  end

  it "emits with the multiple namservers" do
    @domain.netmask "255.255.255.0"
    @domain.gateway "192.168.0.1"
    @domain.nameserver "192.168.0.254"
    @domain.nameserver "192.168.0.253"
    @domain.emit.must_equal "--netmask=255.255.255.0 --gateway=192.168.0.1 --nameserver=192.168.0.254,192.168.0.253"
  end
end