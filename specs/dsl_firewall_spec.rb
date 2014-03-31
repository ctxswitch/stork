require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Firewall" do
  it "must respond to the enabled accessors" do
    Midwife::DSL::Firewall.new.must_respond_to :enabled
    Midwife::DSL::Firewall.new.must_respond_to :enabled=
  end

  it "must respond to the trusted_devices accessors" do
    Midwife::DSL::Firewall.new.must_respond_to :trusted_devices
    Midwife::DSL::Firewall.new.must_respond_to :trusted_devices=
  end

  it "must respond to the ports_allowed accessors" do
    Midwife::DSL::Firewall.new.must_respond_to :ports_allowed
    Midwife::DSL::Firewall.new.must_respond_to :ports_allowed=
  end

  it "must respond to the ssh accessors" do
    Midwife::DSL::Firewall.new.must_respond_to :ssh
    Midwife::DSL::Firewall.new.must_respond_to :ssh=
  end

  it "must respond to the telnet accessors" do
    Midwife::DSL::Firewall.new.must_respond_to :telnet
    Midwife::DSL::Firewall.new.must_respond_to :telnet=
  end

  it "must respond to the smtp accessors" do
    Midwife::DSL::Firewall.new.must_respond_to :smtp
    Midwife::DSL::Firewall.new.must_respond_to :smtp=
  end

  it "must respond to the http accessors" do
    Midwife::DSL::Firewall.new.must_respond_to :http
    Midwife::DSL::Firewall.new.must_respond_to :http=
  end

  it "must respond to the ftp accessors" do
    Midwife::DSL::Firewall.new.must_respond_to :ftp
    Midwife::DSL::Firewall.new.must_respond_to :ftp=
  end

  it "must build disabled" do
    fw = Midwife::DSL::Firewall.build do
      disable
    end
    fw.enabled.must_equal false
  end

  it "must build enabled" do
    fw = Midwife::DSL::Firewall.build do
      trusted 'eth1'
      trusted 'eth2'
      allow '8080:tcp'
      nossh
      telnet
      smtp
      http
      ftp
    end
    fw.enabled.must_equal true
    fw.trusted_devices.must_equal ['eth1', 'eth2']
    fw.ports_allowed.must_equal ['8080:tcp']
    fw.ssh.must_equal false
    fw.telnet.must_equal true
    fw.smtp.must_equal true
    fw.http.must_equal true
    fw.ftp.must_equal true
  end
end
