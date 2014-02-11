require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL::Distros" do
  it "should read and build all the distros" do
    distros = Midwife::DSL::Distros.build

    distro = distros.find('redhat')
    distro.name.must_equal "redhat"
    distro.kernel.must_equal "myredkernel"
    distro.initrd.must_equal "myredinitrd.img"
    distro.url.must_equal "http://example.com/redhat"
    distro.kernel_url.must_equal "http://example.com/redhat/myredkernel"
    distro.initrd_url.must_equal "http://example.com/redhat/myredinitrd.img"

    distro = distros.find('centos')
    distro.name.must_equal "centos"
    distro.kernel.must_equal "mycentkernel"
    distro.initrd.must_equal "mycentinitrd.img"
    distro.url.must_equal "http://example.com/centos"
    distro.kernel_url.must_equal "http://example.com/centos/mycentkernel"
    distro.initrd_url.must_equal "http://example.com/centos/mycentinitrd.img"
  end
end