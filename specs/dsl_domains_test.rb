require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Domains" do
  before :each do
    @domains = Midwife::DSL::Domains.build
  end

  it "reads all of the domains" do
    domain = @domains.find('test')
    domain.name.must_equal 'test'
    domain = @domains.find('private')
    domain.name.must_equal 'private'
    domain = @domains.find('local')
    domain.name.must_equal 'local'
  end
end