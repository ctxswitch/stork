require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Host" do
  it "emits the correct kickstart file without using a domain" do
    host = Midwife::DSL::Host.build "other1.private" do
      template    'default'
      scheme      'default'
      interface   'eth0'
    end
    host.emit.must_equal File.read("specs/files/results/other1.private.ks")
  end

  it "emits the correct kickstart file with a domain defined" do
    host = Midwife::DSL::Host.build "static1.private" do
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