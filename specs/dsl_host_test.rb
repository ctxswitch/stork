require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::Build::Host" do
  it "emits the default kickstart file" do
    host = Midwife::Build::Host.build "default1.local" do
      scheme      'default'
      distro      'centos'
      interface 'eth0' do
        domain    'local'
        bootproto :static
        ip        '192.168.1.100'
      end
    end
    host.emit.must_equal File.read("specs/files/results/default1.local.ks")
  end

  it "emits the correct kickstart file without using a domain" do
    host = Midwife::Build::Host.build "other1.private" do
      template    'default'
      scheme      'default'
      interface   'eth0'
    end
    host.emit.must_equal File.read("specs/files/results/other1.private.ks")
  end

  it "emits the correct kickstart file with a domain defined" do
    host = Midwife::Build::Host.build "static1.private" do
      template    'default'
      scheme      'default'
      interface 'eth0' do
        domain    'local'
        bootproto :static
        ip        '192.168.1.100'
      end
    end
    host.emit.must_equal File.read("specs/files/results/static1.private.ks")
  end
end