require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::Collection::Base" do
  it "should be emumerable" do
    Midwife::Collections::Base.included_modules.must_include Enumerable
  end

  it "should be created" do
    Midwife::Collections::Base.new.must_be_instance_of Midwife::Collections::Base
  end

  it "responds to each" do
    Midwife::Collections::Base.new.must_respond_to :each
  end

  it "responds to validate" do
    Midwife::Collections::Base.new.must_respond_to :validate
  end

  it "should always validate by default" do
    Midwife::Collections::Base.new.validate(1).must_equal true
  end

  it "can add and iterate through values" do
    bc = Midwife::Collections::Base.new
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

    bc = Midwife::Collections::Base.new
    1.upto 5 do |id|
      bc.add(Foo.new(id))
    end
    bc.get(3).id.must_equal 3
  end
end
