require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Resource::Firewall" do
  it "must respond to the enabled accessors" do
    Stork::Resource::Firewall.new.must_respond_to :enabled
    Stork::Resource::Firewall.new.must_respond_to :enabled=
  end

  it "must respond to the trusted_devices accessors" do
    Stork::Resource::Firewall.new.must_respond_to :trusted_devices
    Stork::Resource::Firewall.new.must_respond_to :trusted_devices=
  end

  it "must respond to the allowed_ports accessors" do
    Stork::Resource::Firewall.new.must_respond_to :allowed_ports
    Stork::Resource::Firewall.new.must_respond_to :allowed_ports=
  end

  it "must respond to the ssh accessors" do
    Stork::Resource::Firewall.new.must_respond_to :ssh
    Stork::Resource::Firewall.new.must_respond_to :ssh=
  end

  it "must respond to the telnet accessors" do
    Stork::Resource::Firewall.new.must_respond_to :telnet
    Stork::Resource::Firewall.new.must_respond_to :telnet=
  end

  it "must respond to the smtp accessors" do
    Stork::Resource::Firewall.new.must_respond_to :smtp
    Stork::Resource::Firewall.new.must_respond_to :smtp=
  end

  it "must respond to the http accessors" do
    Stork::Resource::Firewall.new.must_respond_to :http
    Stork::Resource::Firewall.new.must_respond_to :http=
  end

  it "must respond to the ftp accessors" do
    Stork::Resource::Firewall.new.must_respond_to :ftp
    Stork::Resource::Firewall.new.must_respond_to :ftp=
  end

  it "must build disabled" do
    fw = Stork::Resource::Firewall.build do
      disable
    end
    fw.enabled.must_equal false
  end

  it "must build enabled" do
    fw = Stork::Resource::Firewall.build do
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
    fw.allowed_ports.must_equal ['8080:tcp']
    fw.ssh.must_equal false
    fw.telnet.must_equal true
    fw.smtp.must_equal true
    fw.http.must_equal true
    fw.ftp.must_equal true
  end
end
