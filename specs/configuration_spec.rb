require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Configuration" do
  before(:each) do
    @path = File.dirname(__FILE__)
    FileUtils.mkdir_p "#{@path}/tmp"
  end

  after(:each) do
    FileUtils.rm_rf(Dir.glob("#{@path}/tmp/*"))
  end

  it "should create a file if the configuration file does not exist" do
    Stork::Configuration.reset
    Stork::Configuration.to_file("./specs/tmp/config.rb")
    Stork::Configuration.from_file("./specs/tmp/config.rb")
    File.exist?("./specs/tmp/config.rb").must_equal true
    expected_content = <<-EOS.gsub(/^ {6}/, '')
      # Stork configuration file
      path                    "/etc/stork"
      bundle_path             "/etc/stork/bundles"
      authorized_keys_file    "/etc/stork/authorized_keys"
      pxe_path                "/var/lib/tftpboot/pxelinux.cfg"
      db_path                 "/var/lib/stork"
      log_file                "/var/log/stork.log"
      pid_file                "/var/run/stork.pid"
      server                  "localhost"
      port                    9293
      bind                    "0.0.0.0"
      timezone                "America/Los_Angeles"
    EOS
    File.read("./specs/tmp/config.rb").must_equal expected_content
  end
end