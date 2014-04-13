require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Configuration" do
  it "should respond to etc accessors" do
    Stork::Configuration.new.must_respond_to :etc
    Stork::Configuration.new.must_respond_to :etc=
  end

  it "should respond to hosts_path accessors" do
    Stork::Configuration.new.must_respond_to :hosts_path
    Stork::Configuration.new.must_respond_to :hosts_path=
  end

  it "should respond to snippets_path accessors" do
    Stork::Configuration.new.must_respond_to :snippets_path
    Stork::Configuration.new.must_respond_to :snippets_path=
  end

  it "should respond to layouts_path accessors" do
    Stork::Configuration.new.must_respond_to :layouts_path
    Stork::Configuration.new.must_respond_to :layouts_path=
  end

  it "should respond to networks_path accessors" do
    Stork::Configuration.new.must_respond_to :networks_path
    Stork::Configuration.new.must_respond_to :networks_path=
  end

  it "should respond to distros_path accessors" do
    Stork::Configuration.new.must_respond_to :distros_path
    Stork::Configuration.new.must_respond_to :distros_path=
  end

  it "should respond to kickstarts_path accessors" do
    Stork::Configuration.new.must_respond_to :templates_path
    Stork::Configuration.new.must_respond_to :templates_path=
  end

  it "should respond to authorized_keys_file accessors" do
    Stork::Configuration.new.must_respond_to :authorized_keys_file
    Stork::Configuration.new.must_respond_to :authorized_keys_file=
  end

  it "should respond to var accessors" do
    Stork::Configuration.new.must_respond_to :var
    Stork::Configuration.new.must_respond_to :var=
  end

  it "should respond to pxe_path accessors" do
    Stork::Configuration.new.must_respond_to :pxe_path
    Stork::Configuration.new.must_respond_to :pxe_path=
  end

  it "should respond to log_file accessors" do
    Stork::Configuration.new.must_respond_to :log_file
    Stork::Configuration.new.must_respond_to :log_file=
  end

  it "should respond to tmp accessors" do
    Stork::Configuration.new.must_respond_to :tmp
    Stork::Configuration.new.must_respond_to :tmp=
  end

  it "should respond to pid_file accessors" do
    Stork::Configuration.new.must_respond_to :pid_file
    Stork::Configuration.new.must_respond_to :pid_file=
  end

  it "should respond to server accessors" do
    Stork::Configuration.new.must_respond_to :server
    Stork::Configuration.new.must_respond_to :server=
  end

  it "should respond to port accessors" do
    Stork::Configuration.new.must_respond_to :port
    Stork::Configuration.new.must_respond_to :port=
  end

  it "should respond to bind accessors" do
    Stork::Configuration.new.must_respond_to :bind
    Stork::Configuration.new.must_respond_to :bind=
  end

  it "should respond to timezone accessors" do
    Stork::Configuration.new.must_respond_to :timezone
    Stork::Configuration.new.must_respond_to :timezone=
  end

  it "should have the defaults" do
    config = Stork::Configuration.new
    config.etc.must_equal "/etc/stork"
    config.hosts_path.must_equal "/etc/stork/bundles/hosts"
    config.layouts_path.must_equal "/etc/stork/bundles/layouts"
    config.snippets_path.must_equal "/etc/stork/bundles/snippets"
    config.networks_path.must_equal "/etc/stork/bundles/networks"
    config.distros_path.must_equal "/etc/stork/bundles/distros"
    config.authorized_keys_file.must_equal "/etc/stork/authorized_keys"
    config.var.must_equal "/var"
    config.pxe_path.must_equal "/var/lib/tftpboot/pxelinux.cfg"
    config.log_file.must_equal "/var/log/stork.log"
    config.pid_file.must_equal "/var/run/stork.pid"
    config.server.must_equal "localhost"
    config.port.must_equal 9293
    config.bind.must_equal "0.0.0.0"
    config.timezone.must_equal "America/Los_Angeles"
  end

  # it "should load from file" do
  #   config = Stork::Configuration.from_file("./specs/files/configs/stork/opt.rb")
  #   config.etc.must_equal "/opt/etc/stork"
  #   config.hosts_path.must_equal "/opt/etc/stork/hosts"
  #   config.layouts_path.must_equal "/opt/etc/stork/layouts"
  #   config.snippets_path.must_equal "/opt/etc/stork/snippets"
  #   config.networks_path.must_equal "/opt/etc/stork/networks"
  #   config.distros_path.must_equal "/opt/etc/stork/distros"
  #   config.authorized_keys_file.must_equal "/opt/etc/stork/keys/authorized_keys"
  #   config.var.must_equal "/opt/var"
  #   config.pxe_path.must_equal "/opt/var/lib/tftpboot/pxelinux.cfg"
  #   config.log_file.must_equal "/opt/var/log/stork.log"
  #   config.tmp.must_equal "/opt/tmp"
  #   config.pid_file.must_equal "/opt/tmp/stork.pid"
  #   config.server.must_equal "stork.example.org"
  #   config.port.must_equal 5000
  #   config.bind.must_equal "192.168.1.250"
  #   config.timezone.must_equal "America/New_York"
  # end
end