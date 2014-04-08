require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Repo" do
  it "must create a repo" do
    Midwife::DSL::Repo.new('updates').must_be_instance_of Midwife::DSL::Repo
  end

  it "must respond to name" do
    Midwife::DSL::Repo.new('updates').must_respond_to :name
    Midwife::DSL::Repo.new('updates').name.must_equal 'updates'
  end

  it "must respond to the baseurl accessors" do
    Midwife::DSL::Repo.new('updates').must_respond_to :baseurl
    Midwife::DSL::Repo.new('updates').must_respond_to :baseurl=
  end

  it "must respond to the mirrorlist accessors" do
    Midwife::DSL::Repo.new('updates').must_respond_to :mirrorlist
    Midwife::DSL::Repo.new('updates').must_respond_to :mirrorlist=
  end

  it "must only let either baseurl or mirrorlist" do
    proc {
      Midwife::DSL::Repo.new 'updates', baseurl: 'foo', mirrorlist: 'foo'
    }.must_raise(SyntaxError)
  end

  it "must set the baseurl" do
    repo = Midwife::DSL::Repo.new('updates', baseurl: 'http://foo.com')
    repo.baseurl.must_equal 'http://foo.com'
  end

  it "must set the mirrorlist" do
    repo = Midwife::DSL::Repo.new('updates', mirrorlist: 'http://foo.com')
    repo.mirrorlist.must_equal 'http://foo.com'
  end
end
