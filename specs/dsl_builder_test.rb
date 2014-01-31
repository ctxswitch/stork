require File.dirname(__FILE__) + '/spec_helper'

describe Midwife::DSL::Builder do
  it "should read and evaluate a file" do
    arr = Midwife::DSL::Builder.from_file(Array, 'specs/files/builder_array.rb')
    arr.must_equal [1,2,3,4]
  end

  it "should raise an error for a non existent file" do
    proc {
      s = Midwife::DSL::Builder.from_file(Array, 'specs/files/not_available')
    }.must_raise Midwife::NotFound
  end

  it "should evaluate a string" do
    arr = Midwife::DSL::Builder.from_string(Array, 'push 1; push 2; push 3; push 4')
    arr.must_equal [1,2,3,4]
  end
end