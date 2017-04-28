require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Resource::Interface" do
  it "must create an interface" do
    Stork::Resource::Interface.new('eth0').must_be_instance_of Stork::Resource::Interface
  end

  it "should respond to the device method" do
    Stork::Resource::Interface.new('eth0').must_respond_to :device
  end

  it "should respond to the ethtool accessors" do
    Stork::Resource::Interface.new('eth0').must_respond_to :ethtool
    Stork::Resource::Interface.new('eth0').must_respond_to :ethtool=
  end

  it "should respond to the ip accessors" do
    Stork::Resource::Interface.new('eth0').must_respond_to :ip
    Stork::Resource::Interface.new('eth0').must_respond_to :ip=
  end

  it "should respond to the bootproto accessors" do
    Stork::Resource::Interface.new('eth0').must_respond_to :bootproto
    Stork::Resource::Interface.new('eth0').must_respond_to :bootproto=
  end

  it "should respond to the onboot accessors" do
    Stork::Resource::Interface.new('eth0').must_respond_to :onboot
    Stork::Resource::Interface.new('eth0').must_respond_to :onboot=
  end

  it "should respond to the noipv4 accessors" do
    Stork::Resource::Interface.new('eth0').must_respond_to :ipv4
    Stork::Resource::Interface.new('eth0').must_respond_to :ipv4=
  end

  it "should respond to the noipv6 accessors" do
    Stork::Resource::Interface.new('eth0').must_respond_to :ipv6
    Stork::Resource::Interface.new('eth0').must_respond_to :ipv6=
  end

  it "should respond to the nodns accessors" do
    Stork::Resource::Interface.new('eth0').must_respond_to :dns
    Stork::Resource::Interface.new('eth0').must_respond_to :dns=
  end

  it "should respond to the nodefroute accessors" do
    Stork::Resource::Interface.new('eth0').must_respond_to :defroute
    Stork::Resource::Interface.new('eth0').must_respond_to :defroute=
  end

  it "should respond to the mtu accessors" do
    Stork::Resource::Interface.new('eth0').must_respond_to :mtu
    Stork::Resource::Interface.new('eth0').must_respond_to :mtu=
  end

  it "should respond to the netmask accessors" do
    Stork::Resource::Interface.new('eth0').must_respond_to :netmask
  end

  it "should respond to the gateway accessors" do
    Stork::Resource::Interface.new('eth0').must_respond_to :gateway
  end

  it "should respond to the nameservers accessors" do
    Stork::Resource::Interface.new('eth0').must_respond_to :nameservers
  end

  it "should respond to the search_paths accessors" do
    Stork::Resource::Interface.new('eth0').must_respond_to :search_paths
  end

  it "should raise a syntax error if the network is not found" do
    collection = Stork::Collections.new
    proc {
      Stork::Resource::Interface.build "eth0", collection: collection do
        network 'invalid'
      end
    }.must_raise(SyntaxError)
  end

  it "should error on invalid ip addresses" do
    collection = Stork::Collections.new
    proc {
      Stork::Resource::Interface.build "eth0", collection: collection do
        ip '1000.1000.1.1'
      end
    }.must_raise(SyntaxError)

    proc {
      Stork::Resource::Interface.build "eth0", collection: collection do
        ip 'hey.there.buddy'
      end
    }.must_raise(SyntaxError)

    proc {
      Stork::Resource::Interface.build "eth0", collection: collection do
        ip '1.1.1'
      end
    }.must_raise(SyntaxError)
  end

  it "should have dhcp as the default for bootproto" do
    Stork::Resource::Interface.new('eth0').bootproto.must_equal :dhcp
  end

  it "should build without a network definition" do
    collection = Stork::Collections.new
    iface = Stork::Resource::Interface.build "eth0", collection: collection do
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
    iface.bootproto.must_equal :static
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
    collection = Stork::Collections.new
    net = Stork::Resource::Network.build("local") do
      netmask "255.255.0.0"
      gateway "192.168.1.1"
      nameserver "192.168.1.253"
      nameserver "192.168.1.252"
      search_path "example.org"
    end
    collection.networks.add(net)

    iface = Stork::Resource::Interface.build "eth0", collection: collection do
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
    iface.bootproto.must_equal :static
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
