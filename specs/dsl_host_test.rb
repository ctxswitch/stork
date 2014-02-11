require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Host" do
  before :all do
    @host = Midwife::DSL::Host.build "other1.private" do
      template    'default'
      scheme      'default'
      interface   'eth0'
    end
  end

  it "emits the correct kickstart file" do
    @host.emit.must_equal File.read("specs/files/results/other1.private.ks")
  end
end