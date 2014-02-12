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
    iface = Midwife::Build::NetworkInterface.build('eth0') do
      noboot
    end
    iface.noboot.must_equal true
    iface.emit.must_equal "#{@ifaceemit} --onboot=no"
  end

  it "emits with noipv4" do
    iface = Midwife::Build::NetworkInterface.build('eth0') do
      noipv4
    end
    iface.noipv4.must_equal true
    iface.emit.must_equal "#{@ifaceemit} --onboot=yes --noipv4"
  end

  it "emits with noipv6" do
    iface = Midwife::Build::NetworkInterface.build('eth0') do
      noipv6
    end
    iface.noipv6.must_equal true
    iface.emit.must_equal "#{@ifaceemit} --onboot=yes --noipv6"
  end

  it "emits with nodefroute" do
    iface = Midwife::Build::NetworkInterface.build('eth0') do
      nodefroute
    end
    iface.nodefroute.must_equal true
    iface.emit.must_equal "#{@ifaceemit} --onboot=yes --nodefroute"
  end

  it "emits with nodns" do
    iface = Midwife::Build::NetworkInterface.build('eth0') do
      nodns
    end
    iface.nodns.must_equal true
    iface.emit.must_equal "#{@ifaceemit} --onboot=yes --nodns"
  end

  it "emits with ethtool" do
    iface = Midwife::Build::NetworkInterface.build('eth0') do
      ethtool "autoneg off duplex full speed 100"
    end
    iface.ethtool.must_equal "autoneg off duplex full speed 100"
    iface.emit.must_equal "#{@ifaceemit} --onboot=yes --ethtool=\"autoneg off duplex full speed 100\""
  end

  it "emits with mtu" do
    iface = Midwife::Build::NetworkInterface.build('eth0') do
      mtu 1500
    end
    iface.mtu.must_equal 1500
    iface.emit.must_equal "#{@ifaceemit} --onboot=yes --mtu=1500"
  end
end