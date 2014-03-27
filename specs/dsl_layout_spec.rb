require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Layout" do
  it "should be created" do
    Midwife::DSL::Layout.new('test').must_be_instance_of Midwife::DSL::Layout
  end

  it "should respond to the name method" do
    Midwife::DSL::Layout.new('test').must_respond_to :name
  end

  it "should respond to the zerombr accessors" do
    Midwife::DSL::Layout.new('test').must_respond_to :zerombr
    Midwife::DSL::Layout.new('test').must_respond_to :zerombr=
  end

  it "should respond to the clearpart accessors" do
    Midwife::DSL::Layout.new('test').must_respond_to :clearpart
    Midwife::DSL::Layout.new('test').must_respond_to :clearpart=
  end

  it "should respond to the partitions accessors" do
    Midwife::DSL::Layout.new('test').must_respond_to :partitions
    Midwife::DSL::Layout.new('test').must_respond_to :partitions=
  end

  it "must build with inline partitions" do
    layout = Midwife::DSL::Layout.build('test') do
      zerombr
      clearpart
      part '/' do
        size 100
        type "ext4"
        primary
        grow
        recommended
      end
    end
    layout.zerombr.must_equal true
    layout.clearpart.must_equal true
    layout.partitions.size.must_equal 1
    part = layout.partitions.first
    part.size.must_equal 100
    part.type.must_equal "ext4"
    part.primary.must_equal true
    part.grow.must_equal true
    part.recommended.must_equal true
  end

  it "must error if part blocks are not given" do
    proc {
      layout = Midwife::DSL::Layout.build('test') do
        zerombr
        clearpart
      end
    }.must_raise(SyntaxError)
  end
end
