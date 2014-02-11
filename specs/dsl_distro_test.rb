require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Distro" do
  it "should build the distro" do
    distro = Midwife::DSL::Distro.build 'redhat' do
      kernel "mykernel"
      initrd "myinitrd"
      url "http://example.com/redhat"
    end

    distro.name.must_equal "redhat"
    distro.kernel.must_equal "mykernel"
    distro.initrd.must_equal "myinitrd"
    distro.url.must_equal "http://example.com/redhat"
    distro.kernel_url.must_equal "http://example.com/redhat/mykernel"
    distro.initrd_url.must_equal "http://example.com/redhat/myinitrd"
  end
end