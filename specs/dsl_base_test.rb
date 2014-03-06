require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::Build::Base" do
  before(:each) do
    class Test < Midwife::Build::Base
      command :hello
      value :who, required: true
      option :when
      option :where
    end

    @klass = Test
  end

  it "can access command" do
    @klass.new.command.must_equal :hello
  end

  it "can set the value" do
    hello = @klass.build "world"
    hello.who.must_equal "world"
  end

  it "must be invalid if the value is required and not set" do
    hello = @klass.build
    hello.valid?.must_equal false
  end
end