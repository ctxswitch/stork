require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::Build::Host" do
  it "should set the selinux value" do
    host = Midwife::Build::Host.build "default1.local" do
      selinux :enforcing
    end
    host.selinux.must_equal 'enforcing'
  end

  it "should set the timezone value" do
    host = Midwife::Build::Host.build "default1.local" do
      timezone 'Pacific/Fiji'
    end
    host.timezone.must_equal 'Pacific/Fiji'
  end

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
    # Get rid of the password line since it sets a random one every time
    actual = host.emit.gsub(/^rootpw.*$/, '')
    expected = File.read("specs/files/results/default1.local.ks").gsub(/^rootpw.*$/, '')
    actual.must_equal expected 
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