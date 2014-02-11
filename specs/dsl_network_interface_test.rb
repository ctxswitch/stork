require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::NetworkInterface" do
  before :each do
    @iface = Midwife::DSL::NetworkInterface.new('eth0')
    @domain = Midwife::DSL::Domain.build('local') do
      netmask "255.255.255.0"
      gateway "192.168.0.1"
      nameserver "192.168.0.254"
      nameserver "192.168.0.253"
    end
    @ifaceemit = "network --device=eth0 --bootproto=dhcp"
  end

  it "emits the correct kickstart lines with defaults" do
    @iface.emit.must_equal "#{@ifaceemit} --onboot=yes"
  end

  it "emits ip and domain info on static" do
    @iface.ip "192.168.0.10"
    @iface.domain @domain
    @iface.bootproto :static
    @iface.emit.must_equal "network --device=eth0 --bootproto=static --ip=192.168.0.10 #{@domain.emit} --onboot=yes"
  end

  it "emits with noboot" do
    @iface.noboot
    @iface.emit.must_equal "#{@ifaceemit} --onboot=no"
  end

  it "emits with noipv4" do
    @iface.noipv4
    @iface.emit.must_equal "#{@ifaceemit} --onboot=yes --noipv4"
  end

  it "emits with noipv6" do
    @iface.noipv6
    @iface.emit.must_equal "#{@ifaceemit} --onboot=yes --noipv6"
  end

  it "emits with nodefroute" do
    @iface.nodefroute
    @iface.emit.must_equal "#{@ifaceemit} --onboot=yes --nodefroute"
  end

  it "emits with nodns" do
    @iface.nodns
    @iface.emit.must_equal "#{@ifaceemit} --onboot=yes --nodns"
  end

  it "emits with ethtool" do
    @iface.ethtool "autoneg off duplex full speed 100"
    @iface.emit.must_equal "#{@ifaceemit} --onboot=yes --ethtool=\"autoneg off duplex full speed 100\""
  end

  it "emits with mtu" do
    @iface.mtu 1500
    @iface.emit.must_equal "#{@ifaceemit} --onboot=yes --mtu=1500"
  end
end