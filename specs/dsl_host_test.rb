require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Host" do
  before :all do
    # quicky until I get it mocked
    @config = Midwife::Config.build('specs/files/configs')
  end

  it "emits the correct kickstart file" do
    @config.hosts['other1.private'].emit.must_equal File.read("specs/files/results/other1.private.ks")
  end
end