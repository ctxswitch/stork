require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::Configuration" do
  it "should set the config through a file" do
    @cfg = Midwife::Configuration.new
    @cfg.from_file('./specs/files/configs/config.rb')

    @cfg.path.must_equal './specs/files/configs'
    @cfg.pxe_path.must_equal './tmp/pxeboot'
    @cfg.log_file.must_equal './tmp/midwife.log'
    @cfg.pid_file.must_equal './tmp/midwife.pid'
    @cfg.authorized_keys.must_equal File.read('./specs/files/fake.pub')
  end
end