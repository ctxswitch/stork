require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Configuration" do
  before(:each) do
    @path = File.dirname(__FILE__)
    FileUtils.mkdir_p "#{@path}/tmp"
  end

  after(:each) do
    FileUtils.rm_rf(Dir.glob("#{@path}/tmp/*"))
  end

  # it "should respond to path accessors" do
  #   Stork::Configuration.new.must_respond_to :path
  #   Stork::Configuration.new.must_respond_to :path=
  # end

  # it "should respond to bundles accessors" do
  #   Stork::Configuration.new.must_respond_to :bundle_path
  #   Stork::Configuration.new.must_respond_to :bundle_path=
  # end

  # it "should respond to hosts_path" do
  #   Stork::Configuration.new.must_respond_to :hosts_path
  # end

  # it "should respond to snippets_path" do
  #   Stork::Configuration.new.must_respond_to :snippets_path
  # end

  # it "should respond to layouts_path accessors" do
  #   Stork::Configuration.new.must_respond_to :layouts_path
  # end

  # it "should respond to networks_path accessors" do
  #   Stork::Configuration.new.must_respond_to :networks_path
  # end

  # it "should respond to distros_path accessors" do
  #   Stork::Configuration.new.must_respond_to :distros_path
  # end

  # it "should respond to templates_path accessors" do
  #   Stork::Configuration.new.must_respond_to :templates_path
  # end

  # it "should respond to chefs_path accessors" do
  #   Stork::Configuration.new.must_respond_to :chefs_path
  # end

  # it "should respond to authorized_keys_file accessors" do
  #   Stork::Configuration.new.must_respond_to :authorized_keys_file
  #   Stork::Configuration.new.must_respond_to :authorized_keys_file=
  # end

  # it "should respond to pxe_path accessors" do
  #   Stork::Configuration.new.must_respond_to :pxe_path
  #   Stork::Configuration.new.must_respond_to :pxe_path=
  # end

  # it "should respond to log_file accessors" do
  #   Stork::Configuration.new.must_respond_to :log_file
  #   Stork::Configuration.new.must_respond_to :log_file=
  # end

  # it "should respond to pid_file accessors" do
  #   Stork::Configuration.new.must_respond_to :pid_file
  #   Stork::Configuration.new.must_respond_to :pid_file=
  # end

  # it "should respond to server accessors" do
  #   Stork::Configuration.new.must_respond_to :server
  #   Stork::Configuration.new.must_respond_to :server=
  # end

  # it "should respond to port accessors" do
  #   Stork::Configuration.new.must_respond_to :port
  #   Stork::Configuration.new.must_respond_to :port=
  # end

  # it "should respond to bind accessors" do
  #   Stork::Configuration.new.must_respond_to :bind
  #   Stork::Configuration.new.must_respond_to :bind=
  # end

  # it "should respond to timezone accessors" do
  #   Stork::Configuration.new.must_respond_to :timezone
  #   Stork::Configuration.new.must_respond_to :timezone=
  # end

#   it "should have the defaults" do
#     config = Stork::Configuration
#     config.path.must_equal                  "/etc/stork"
#     config.bundle_path.must_equal           "/etc/stork/bundles"
#     config.hosts_path.must_equal            "/etc/stork/bundles/hosts"
#     config.layouts_path.must_equal          "/etc/stork/bundles/layouts"
#     config.snippets_path.must_equal         "/etc/stork/bundles/snippets"
#     config.networks_path.must_equal         "/etc/stork/bundles/networks"
#     config.distros_path.must_equal          "/etc/stork/bundles/distros"
#     config.chefs_path.must_equal            "/etc/stork/bundles/chefs"
#     config.templates_path.must_equal        "/etc/stork/bundles/templates"
#     config.authorized_keys_file.must_equal  "/etc/stork/authorized_keys"
#     config.pxe_path.must_equal              "/var/lib/tftpboot/pxelinux.cfg"
#     config.log_file.must_equal              "/var/log/stork.log"
#     config.pid_file.must_equal              "/var/run/stork.pid"
#     config.server.must_equal                "localhost"
#     config.port.must_equal                  9293
#     config.bind.must_equal                  "0.0.0.0"
#     config.timezone.must_equal              "America/Los_Angeles"
#   end

#     it "should load from file" do
#     config = Stork::Configuration.from_file("./specs/stork/config.rb")
#     config.path.must_equal                  "./specs/stork"
#     config.bundle_path.must_equal           "./specs/stork/bundles"
#     config.hosts_path.must_equal            "./specs/stork/bundles/hosts"
#     config.layouts_path.must_equal          "./specs/stork/bundles/layouts"
#     config.snippets_path.must_equal         "./specs/stork/bundles/snippets"
#     config.networks_path.must_equal         "./specs/stork/bundles/networks"
#     config.distros_path.must_equal          "./specs/stork/bundles/distros"
#     config.chefs_path.must_equal            "./specs/stork/bundles/chefs"
#     config.templates_path.must_equal        "./specs/stork/bundles/templates"
#     config.authorized_keys_file.must_equal  "./specs/stork/authorized_keys"
#     config.pxe_path.must_equal              "./specs/tmp/pxeboot"
#     config.log_file.must_equal              "./specs/tmp/stork.log"
#     config.pid_file.must_equal              "./specs/tmp/stork.pid"
#     config.server.must_equal                "localhost"
#     config.port.must_equal                  5000
#     config.bind.must_equal                  "0.0.0.0"
#     config.timezone.must_equal              "America/New_York"
#   end

#   it "should create a file if the configuration file does not exist" do
#     config = Stork::Configuration.from_file("./specs/tmp/config.rb")
#     File.exist?("./specs/tmp/config.rb").must_equal true
#     expected_content = <<-EOS
# # Stork configuration file"
# path                    "/etc/stork"
# bundle_path             "/etc/stork/bundles"
# authorized_keys_file    "/etc/stork/authorized_keys"
# pxe_path                "/var/lib/tftpboot/pxelinux.cfg"
# log_file                "/var/log/stork.log"
# pid_file                "/var/run/stork.pid"
# server                  "localhost"
# port                    9293
# bind                    "0.0.0.0"
# timezone                "America/Los_Angeles"
#     EOS
#     File.read("./specs/tmp/config.rb").must_equal expected_content
#   end
end