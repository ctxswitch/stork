require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Objects::Distro" do
  it "should be created" do
    Stork::Objects::Distro.new("test").must_be_instance_of Stork::Objects::Distro
  end

  it "should respond to the name method" do
    Stork::Objects::Distro.new("test").must_respond_to :name
  end

  it "should respond to the kernel accessors" do
    Stork::Objects::Distro.new("test").must_respond_to :kernel
    Stork::Objects::Distro.new("test").must_respond_to :kernel=
  end

  it "should respond to the image accessors" do
    Stork::Objects::Distro.new("test").must_respond_to :image
    Stork::Objects::Distro.new("test").must_respond_to :image=
  end

  it "should respond to the url accessors" do
    Stork::Objects::Distro.new("test").must_respond_to :url
    Stork::Objects::Distro.new("test").must_respond_to :url=
  end

  it "should build" do
    distro = Stork::Objects::Distro.build("test") do
      kernel "vmlinuz"
      image "initrd.img"
      url "http://mirror.example.org"
    end
    distro.name.must_equal "test"
    distro.kernel.must_equal "vmlinuz"
    distro.image.must_equal "initrd.img"
    distro.url.must_equal "http://mirror.example.org"
  end
end