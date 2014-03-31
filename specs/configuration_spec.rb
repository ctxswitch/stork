require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::Configuration" do
  it "should respond to etc accessors" do
    Midwife::Configuration.new.must_respond_to :etc
    Midwife::Configuration.new.must_respond_to :etc=
  end

  it "should respond to hosts_path accessors" do
    Midwife::Configuration.new.must_respond_to :hosts_path
    Midwife::Configuration.new.must_respond_to :hosts_path=
  end

  it "should respond to snippets_path accessors" do
    Midwife::Configuration.new.must_respond_to :snippets_path
    Midwife::Configuration.new.must_respond_to :snippets_path=
  end

  it "should respond to layouts_path accessors" do
    Midwife::Configuration.new.must_respond_to :layouts_path
    Midwife::Configuration.new.must_respond_to :layouts_path=
  end

  it "should respond to networks_path accessors" do
    Midwife::Configuration.new.must_respond_to :networks_path
    Midwife::Configuration.new.must_respond_to :networks_path=
  end

  it "should respond to distros_path accessors" do
    Midwife::Configuration.new.must_respond_to :distros_path
    Midwife::Configuration.new.must_respond_to :distros_path=
  end

  it "should respond to kickstarts_path accessors" do
    Midwife::Configuration.new.must_respond_to :templates_path
    Midwife::Configuration.new.must_respond_to :templates_path=
  end

  it "should respond to authorized_keys_file accessors" do
    Midwife::Configuration.new.must_respond_to :authorized_keys_file
    Midwife::Configuration.new.must_respond_to :authorized_keys_file=
  end

  it "should respond to var accessors" do
    Midwife::Configuration.new.must_respond_to :var
    Midwife::Configuration.new.must_respond_to :var=
  end

  it "should respond to pxe_path accessors" do
    Midwife::Configuration.new.must_respond_to :pxe_path
    Midwife::Configuration.new.must_respond_to :pxe_path=
  end

  it "should respond to log_file accessors" do
    Midwife::Configuration.new.must_respond_to :log_file
    Midwife::Configuration.new.must_respond_to :log_file=
  end

  it "should respond to tmp accessors" do
    Midwife::Configuration.new.must_respond_to :tmp
    Midwife::Configuration.new.must_respond_to :tmp=
  end

  it "should respond to pid_file accessors" do
    Midwife::Configuration.new.must_respond_to :pid_file
    Midwife::Configuration.new.must_respond_to :pid_file=
  end

  it "should respond to server accessors" do
    Midwife::Configuration.new.must_respond_to :server
    Midwife::Configuration.new.must_respond_to :server=
  end

  it "should respond to port accessors" do
    Midwife::Configuration.new.must_respond_to :port
    Midwife::Configuration.new.must_respond_to :port=
  end

  it "should respond to bind accessors" do
    Midwife::Configuration.new.must_respond_to :bind
    Midwife::Configuration.new.must_respond_to :bind=
  end

  it "should respond to timezone accessors" do
    Midwife::Configuration.new.must_respond_to :timezone
    Midwife::Configuration.new.must_respond_to :timezone=
  end

  it "should have the defaults" do
    config = Midwife::Configuration.new
    config.etc.must_equal "/etc/midwife"
    config.hosts_path.must_equal "/etc/midwife/hosts"
    config.layouts_path.must_equal "/etc/midwife/layouts"
    config.snippets_path.must_equal "/etc/midwife/snippets"
    config.networks_path.must_equal "/etc/midwife/networks"
    config.distros_path.must_equal "/etc/midwife/distros"
    config.authorized_keys_file.must_equal "/etc/midwife/keys/authorized_keys"
    config.var.must_equal "/var"
    config.pxe_path.must_equal "/var/lib/tftpboot/pxelinux.cfg"
    config.log_file.must_equal "/var/log/midwife.log"
    config.tmp.must_equal "/tmp"
    config.pid_file.must_equal "/tmp/midwife.pid"
    config.server.must_equal "localhost"
    config.port.must_equal 4000
    config.bind.must_equal "0.0.0.0"
    config.timezone.must_equal "America/Los_Angeles"
  end

  it "should load from file" do
    config = Midwife::Configuration.from_file("./specs/files/configs/midwife/opt.rb")
    config.etc.must_equal "/opt/etc/midwife"
    config.hosts_path.must_equal "/opt/etc/midwife/hosts"
    config.layouts_path.must_equal "/opt/etc/midwife/layouts"
    config.snippets_path.must_equal "/opt/etc/midwife/snippets"
    config.networks_path.must_equal "/opt/etc/midwife/networks"
    config.distros_path.must_equal "/opt/etc/midwife/distros"
    config.authorized_keys_file.must_equal "/opt/etc/midwife/keys/authorized_keys"
    config.var.must_equal "/opt/var"
    config.pxe_path.must_equal "/opt/var/lib/tftpboot/pxelinux.cfg"
    config.log_file.must_equal "/opt/var/log/midwife.log"
    config.tmp.must_equal "/opt/tmp"
    config.pid_file.must_equal "/opt/tmp/midwife.pid"
    config.server.must_equal "midwife.example.org"
    config.port.must_equal 5000
    config.bind.must_equal "192.168.1.250"
    config.timezone.must_equal "America/New_York"
  end
end
