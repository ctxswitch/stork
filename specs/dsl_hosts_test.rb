require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Hosts" do
  include Midwife::Core

  it "should read all of the hosts" do
    hosts.size.must_equal 12
    
    (1..10).to_a.each do |num|
      host = hosts.find("system#{num}.local")
      host.name.must_equal "system#{num}.local"
    end

    host = hosts.find('other1.private')
    host.name.must_equal 'other1.private'

    host = hosts.find('static1.private')
    host.name.must_equal 'static1.private'
  end
end