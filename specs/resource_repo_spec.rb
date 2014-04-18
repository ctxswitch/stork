require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Resource::Repo" do
  it "must create a repo" do
    Stork::Resource::Repo.new('updates', baseurl: "foo").must_be_instance_of Stork::Resource::Repo
  end

  it "must respond to name" do
    Stork::Resource::Repo.new('updates', baseurl: "foo").must_respond_to :name
    Stork::Resource::Repo.new('updates', baseurl: "foo").name.must_equal 'updates'
  end

  it "must respond to the baseurl accessors" do
    Stork::Resource::Repo.new('updates', baseurl: "foo").must_respond_to :baseurl
    Stork::Resource::Repo.new('updates', baseurl: "foo").must_respond_to :baseurl=
  end

  it "must respond to the mirrorlist accessors" do
    Stork::Resource::Repo.new('updates', baseurl: "foo").must_respond_to :mirrorlist
    Stork::Resource::Repo.new('updates', baseurl: "foo").must_respond_to :mirrorlist=
  end

  it "must only let either baseurl or mirrorlist" do
    proc {
      Stork::Resource::Repo.new 'updates', baseurl: 'foo', mirrorlist: 'foo'
    }.must_raise(SyntaxError)
  end

  it "must require either baseurl or mirrorlist" do
    proc {
      Stork::Resource::Repo.new 'updates'
    }.must_raise(SyntaxError)
  end

  it "must set the baseurl" do
    repo = Stork::Resource::Repo.new('updates', baseurl: 'http://foo.com')
    repo.baseurl.must_equal 'http://foo.com'
  end

  it "must set the mirrorlist" do
    repo = Stork::Resource::Repo.new('updates', mirrorlist: 'http://foo.com')
    repo.mirrorlist.must_equal 'http://foo.com'
  end
end
