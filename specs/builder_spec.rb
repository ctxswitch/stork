require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::Builder" do
  # it "must build a host" do
  #   hostrb = File.dirname(__FILE__) + '/files/configs/hosts/example.org.rb'
  #   builder = Midwife::Builder.new(nil)
  #   builder.instance_eval(File.read(hostrb))
  #   collection = builder.collection
  #   hosts = collection.hosts
  #   # puts hosts.inspect
  # end
  it "must load everything" do
    builder = Midwife::Builder.load(configuration)
    collection = builder.collection
    collection.hosts.size.must_equal 1
    collection.chefs.size.must_equal 1
    collection.distros.size.must_equal 1
    collection.layouts.size.must_equal 1
    collection.networks.size.must_equal 2
    collection.templates.size.must_equal 1
  end
end
