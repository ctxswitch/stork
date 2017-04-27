require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Collections" do
  it "should be created" do
    Stork::Collections.new.must_be_instance_of Stork::Collections
  end

  it "responds to the hosts method" do
    Stork::Collections.new.must_respond_to :hosts
  end

  it "responds to the layouts method" do
    Stork::Collections.new.must_respond_to :layouts
  end

  it "responds to the networks method" do
    Stork::Collections.new.must_respond_to :networks
  end

  it "responds to the distros method" do
    Stork::Collections.new.must_respond_to :distros
  end
end

describe "Stork::Collection::Base" do
  it "should be emumerable" do
    Stork::Collection::Base.included_modules.must_include Enumerable
  end

  it "should be created" do
    Stork::Collection::Base.new.must_be_instance_of Stork::Collection::Base
  end

  it "responds to each" do
    Stork::Collection::Base.new.must_respond_to :each
  end

  it "responds to validate" do
    Stork::Collection::Base.new.must_respond_to :validate
  end

  it "should always validate by default" do
    Stork::Collection::Base.new.validate(1).must_equal true
  end

  it "can add and iterate through values" do
    bc = Stork::Collection::Base.new
    bc.add(1,2,3,4,5)
    1.upto 5 do |value|
      bc.include?(value)
    end
  end

  it "must get a value from the collection" do
    class Foo
      attr_reader :id
      def initialize(id)
        @id = id
      end
    end

    bc = Stork::Collection::Base.new
    1.upto 5 do |id|
      bc.add(Foo.new(id))
    end
    bc.get(3).id.must_equal 3
  end
end