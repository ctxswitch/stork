require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::Configuration" do
  it "should set the config through a file" do
    @cfg = Midwife::Configuration.new
    @cfg.from_file('specs/files/configs/config.rb')

    @cfg.path.must_equal './specs/files/configs'
    @cfg.pxe_path.must_equal './tmp/pxeboot'
    @cfg.log_file.must_equal './tmp/midwife.log'
    @cfg.pid_file.must_equal './tmp/midwife.pid'
    @cfg.chef_validation_key.must_equal '/specs/files/snakeoil-validation.pem'
    @cfg.chef_client_key.must_equal '/specs/files/snakeoil-root.pem'
    @cfg.ssh_pubkeys.must_equal ['/specs/files/fake.pub']
  end
end