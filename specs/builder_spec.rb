require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Builder" do
  before(:each) do
    load_config
  end

  it "must load everything" do
    builder = Stork::Builder.load
    collection = builder.collection
    collection.hosts.size.must_equal 11
    collection.distros.size.must_equal 1
    collection.layouts.size.must_equal 1
    collection.networks.size.must_equal 2
    collection.templates.size.must_equal 1
  end
end
