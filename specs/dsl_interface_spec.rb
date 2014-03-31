require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Interface" do
  it "must create an interface" do
    Midwife::DSL::Interface.new('eth0').must_be_instance_of Midwife::DSL::Interface
  end

  it "should respond to the device method" do
    Midwife::DSL::Interface.new('eth0').must_respond_to :device
  end

  it "should respond to the ethtool accessors" do
    Midwife::DSL::Interface.new('eth0').must_respond_to :ethtool
    Midwife::DSL::Interface.new('eth0').must_respond_to :ethtool=
  end

  it "should respond to the ip accessors" do
    Midwife::DSL::Interface.new('eth0').must_respond_to :ip
    Midwife::DSL::Interface.new('eth0').must_respond_to :ip=
  end

  it "should respond to the bootproto accessors" do
    Midwife::DSL::Interface.new('eth0').must_respond_to :bootproto
    Midwife::DSL::Interface.new('eth0').must_respond_to :bootproto=
  end

  it "should respond to the onboot accessors" do
    Midwife::DSL::Interface.new('eth0').must_respond_to :onboot
    Midwife::DSL::Interface.new('eth0').must_respond_to :onboot=
  end

  it "should respond to the noipv4 accessors" do
    Midwife::DSL::Interface.new('eth0').must_respond_to :noipv4
    Midwife::DSL::Interface.new('eth0').must_respond_to :noipv4=
  end

  it "should respond to the noipv6 accessors" do
    Midwife::DSL::Interface.new('eth0').must_respond_to :noipv6
    Midwife::DSL::Interface.new('eth0').must_respond_to :noipv6=
  end

  it "should respond to the nodns accessors" do
    Midwife::DSL::Interface.new('eth0').must_respond_to :nodns
    Midwife::DSL::Interface.new('eth0').must_respond_to :nodns=
  end

  it "should respond to the nodefroute accessors" do
    Midwife::DSL::Interface.new('eth0').must_respond_to :nodefroute
    Midwife::DSL::Interface.new('eth0').must_respond_to :nodefroute=
  end

  it "should respond to the mtu accessors" do
    Midwife::DSL::Interface.new('eth0').must_respond_to :mtu
    Midwife::DSL::Interface.new('eth0').must_respond_to :mtu=
  end

  it "should respond to the netmask accessors" do
    Midwife::DSL::Interface.new('eth0').must_respond_to :netmask
    Midwife::DSL::Interface.new('eth0').must_respond_to :netmask=
  end

  it "should respond to the gateway accessors" do
    Midwife::DSL::Interface.new('eth0').must_respond_to :gateway
    Midwife::DSL::Interface.new('eth0').must_respond_to :gateway=
  end

  it "should respond to the nameservers accessors" do
    Midwife::DSL::Interface.new('eth0').must_respond_to :nameservers
    Midwife::DSL::Interface.new('eth0').must_respond_to :nameservers=
  end

  it "should respond to the search_paths accessors" do
    Midwife::DSL::Interface.new('eth0').must_respond_to :search_paths
    Midwife::DSL::Interface.new('eth0').must_respond_to :search_paths=
  end

  it "should raise a syntax error if the network is not found" do
    proc {
      iface = Midwife::DSL::Interface.build(collection, 'eth0') do
        network 'invalid'
      end
    }.must_raise(SyntaxError)
  end

  it "should build without a network definition" do
    collection = Midwife::Collection.new
    iface = Midwife::DSL::Interface.build(collection, 'eth0') do
      ethtool "ethtool args"
      ip "192.168.1.10"
      bootproto :static
      onboot
      noipv4
      noipv6
      nodns
      nodefroute
      mtu 4000
      netmask "255.255.0.0"
      gateway "192.168.1.1"
      nameserver "192.168.1.253"
      nameserver "192.168.1.252"
      search_path "example.org"
    end
    iface.device.must_equal "eth0"
    iface.ethtool.must_equal "ethtool args"
    iface.ip.must_equal "192.168.1.10"
    iface.bootproto.must_equal "static"
    iface.onboot.must_equal true
    iface.noipv4.must_equal true
    iface.noipv6.must_equal true
    iface.nodns.must_equal true
    iface.nodefroute.must_equal true
    iface.mtu.must_equal 4000
    iface.netmask.must_equal "255.255.0.0"
    iface.gateway.must_equal "192.168.1.1"
    iface.nameservers.must_equal ["192.168.1.253", "192.168.1.252"]
    iface.search_paths.must_equal ["example.org"]
  end

  it "should build with a network definition" do
    collection = Midwife::Collection.new
    net = Midwife::DSL::Network.build("local") do
      netmask "255.255.0.0"
      gateway "192.168.1.1"
      nameserver "192.168.1.253"
      nameserver "192.168.1.252"
      search_path "example.org"
    end
    collection.networks.add(net)

    iface = Midwife::DSL::Interface.build(collection, 'eth0') do
      ethtool "ethtool args"
      ip "192.168.1.10"
      bootproto :static
      onboot
      noipv4
      noipv6
      nodns
      nodefroute
      mtu 4000
      network "local"
    end
    iface.device.must_equal "eth0"
    iface.ethtool.must_equal "ethtool args"
    iface.ip.must_equal "192.168.1.10"
    iface.bootproto.must_equal "static"
    iface.onboot.must_equal true
    iface.noipv4.must_equal true
    iface.noipv6.must_equal true
    iface.nodns.must_equal true
    iface.nodefroute.must_equal true
    iface.mtu.must_equal 4000
    iface.netmask.must_equal "255.255.0.0"
    iface.gateway.must_equal "192.168.1.1"
    iface.nameservers.must_equal ["192.168.1.253", "192.168.1.252"]
    iface.search_paths.must_equal ["example.org"]
  end
end
