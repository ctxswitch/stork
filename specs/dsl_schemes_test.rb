require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Schemes" do
  before :each do
    @schemes = Midwife::DSL::Schemes.build
  end

  it "reads all of the schemes" do
    scheme = @schemes.find('default')
    scheme.name.must_equal 'default'
    scheme = @schemes.find('split')
    scheme.name.must_equal 'split'
  end
end