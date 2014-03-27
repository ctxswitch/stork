require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::Collection" do
  it "should be created" do
    Midwife::Collection.new.must_be_instance_of Midwife::Collection
  end

  it "responds to the hosts method" do
    Midwife::Collection.new.must_respond_to :hosts
  end

  it "responds to the layouts method" do
    Midwife::Collection.new.must_respond_to :layouts
  end

  it "responds to the networks method" do
    Midwife::Collection.new.must_respond_to :networks
  end

  it "responds to the chefs method" do
    Midwife::Collection.new.must_respond_to :chefs
  end

  it "responds to the distros method" do
    Midwife::Collection.new.must_respond_to :distros
  end
end
