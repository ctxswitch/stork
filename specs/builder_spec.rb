require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::Builder" do
  it "must build a host" do
    hostrb = File.dirname(__FILE__) + '/files/configs/hosts/example.org.rb'
    builder = Midwife::Builder.new(nil)
    builder.instance_eval(File.read(hostrb))
    collection = builder.collection
    hosts = collection.hosts
    # puts hosts.inspect
  end
end
