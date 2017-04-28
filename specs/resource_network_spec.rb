require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Resource::Network" do
  it "must create a network" do
    Stork::Resource::Network.new("local").must_be_instance_of Stork::Resource::Network
  end

  it "must respond to the name method" do
    Stork::Resource::Network.new("local").must_respond_to :name
  end

  it "must respond to the netmask accessors" do
    Stork::Resource::Network.new("local").must_respond_to :netmask
    Stork::Resource::Network.new("local").must_respond_to :netmask=
  end

  it "must respond to the gateway accessors" do
    Stork::Resource::Network.new("local").must_respond_to :gateway
    Stork::Resource::Network.new("local").must_respond_to :gateway=
  end

  it "must respond to the nameservers accessors" do
    Stork::Resource::Network.new("local").must_respond_to :nameservers
    Stork::Resource::Network.new("local").must_respond_to :nameservers=
  end

  it "must respond to the search_paths accessors" do
    Stork::Resource::Network.new("local").must_respond_to :search_paths
    Stork::Resource::Network.new("local").must_respond_to :search_paths=
  end

  it "must error if the netmask given is invalid" do
    proc {
      Stork::Resource::Network.build "test" do
        netmask '2555555.255.255.0'
      end
    }.must_raise(SyntaxError)

    proc {
      Stork::Resource::Network.build "test" do
        netmask '255.255.255.foo'
      end
    }.must_raise(SyntaxError)

    proc {
      Stork::Resource::Network.build "test" do
        netmask 'howdy.there.pilgrim'
      end
    }.must_raise(SyntaxError)
  end

  it "must error if the gateway is invalid" do
    proc {
      Stork::Resource::Network.build "test" do
        gateway '10.1.1.1111'
      end
    }.must_raise(SyntaxError)

    proc {
      Stork::Resource::Network.build "test" do
        gateway '10.1.1.blah'
      end
    }.must_raise(SyntaxError)

    proc {
      Stork::Resource::Network.build "test" do
        gateway 'wow, this is a really cool gateway'
      end
    }.must_raise(SyntaxError)
  end

  it "must error if the nameserver are invalid" do
    proc {
      Stork::Resource::Network.build "test" do
        nameserver 'superfly'
        nameserver '8.8.8.8'
      end
    }.must_raise(SyntaxError)

    proc {
      Stork::Resource::Network.build "test" do
        nameserver '8.8.8.8'
        nameserver 'superfly'
      end
    }.must_raise(SyntaxError)
  end

  it "should build" do
    net = Stork::Resource::Network.build("local") do
      netmask "255.255.255.0"
      gateway "192.168.1.1"
      nameserver "8.8.8.8"
      nameserver "8.8.8.9"
      search_path "example.org"
    end
    net.netmask.must_equal "255.255.255.0"
    net.gateway.must_equal "192.168.1.1"
    net.nameservers.must_equal ["8.8.8.8", "8.8.8.9"]
    net.search_paths.must_equal ["example.org"]
  end
end
