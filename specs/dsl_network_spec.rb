require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Network" do
  it "must create a network" do
    Midwife::DSL::Network.new("local").must_be_instance_of Midwife::DSL::Network
  end

  it "must respond to the name method" do
    Midwife::DSL::Network.new("local").must_respond_to :name
  end

  it "must respond to the netmask accessors" do
    Midwife::DSL::Network.new("local").must_respond_to :netmask
    Midwife::DSL::Network.new("local").must_respond_to :netmask=
  end

  it "must respond to the gateway accessors" do
    Midwife::DSL::Network.new("local").must_respond_to :gateway
    Midwife::DSL::Network.new("local").must_respond_to :gateway=
  end

  it "must respond to the nameservers accessors" do
    Midwife::DSL::Network.new("local").must_respond_to :nameservers
    Midwife::DSL::Network.new("local").must_respond_to :nameservers=
  end

  it "must respond to the search_paths accessors" do
    Midwife::DSL::Network.new("local").must_respond_to :search_paths
    Midwife::DSL::Network.new("local").must_respond_to :search_paths=
  end

  it "should build" do
    net = Midwife::DSL::Network.build("local") do
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
