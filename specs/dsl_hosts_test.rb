require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Hosts" do
  before :all do
    @hosts = Midwife::DSL::Hosts.build
  end

  it "should read all of the hosts" do
    @hosts.size.must_equal 11
    
    (1..10).to_a.each do |num|
      host = @hosts.find("system#{num}.local")
      host.name.must_equal "system#{num}.local"
    end

    host = @hosts.find('other1.private')
    host.name.must_equal 'other1.private'
  end

  it "should emit the correct kickstart" do
    host = @hosts.find("other1.private")
    host.emit.must_equal File.read("specs/files/results/other1.private.ks")
  end
end