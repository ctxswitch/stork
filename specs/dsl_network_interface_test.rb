require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::Build::NetworkInterface" do
  include Midwife::Core
  before :each do
    @iface = Midwife::Build::NetworkInterface.build('eth0')
    @domain = Midwife::Build::Domain.find('local')
    @ifaceemit = "network --device=eth0 --bootproto=dhcp"
  end

  it "emits the correct kickstart lines with defaults" do
    @iface.emit.must_equal "#{@ifaceemit} --onboot=yes"
  end

  it "emits ip and domain info on static" do
    @iface.set_ip "192.168.0.10"
    @iface.set_domain 'local'
    @iface.set_bootproto :static
    @iface.emit.must_equal "network --device=eth0 --bootproto=static --ip=192.168.0.10 #{@domain.emit} --onboot=yes"
  end

  it "emits with noboot" do
    @iface.set_noboot
    @iface.emit.must_equal "#{@ifaceemit} --onboot=no"
  end

  it "emits with noipv4" do
    @iface.set_noipv4
    @iface.emit.must_equal "#{@ifaceemit} --onboot=yes --noipv4"
  end

  it "emits with noipv6" do
    @iface.set_noipv6
    @iface.emit.must_equal "#{@ifaceemit} --onboot=yes --noipv6"
  end

  it "emits with nodefroute" do
    @iface.set_nodefroute
    @iface.emit.must_equal "#{@ifaceemit} --onboot=yes --nodefroute"
  end

  it "emits with nodns" do
    @iface.set_nodns
    @iface.emit.must_equal "#{@ifaceemit} --onboot=yes --nodns"
  end

  it "emits with ethtool" do
    @iface.set_ethtool "autoneg off duplex full speed 100"
    @iface.emit.must_equal "#{@ifaceemit} --onboot=yes --ethtool=\"autoneg off duplex full speed 100\""
  end

  it "emits with mtu" do
    @iface.set_mtu 1500
    @iface.emit.must_equal "#{@ifaceemit} --onboot=yes --mtu=1500"
  end
end