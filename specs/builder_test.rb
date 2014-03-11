# require File.dirname(__FILE__) + '/spec_helper'

# describe Midwife::Builder do
#   it "should load everything in" do
#     @builder = Midwife::Builder.build
#   end

#   it "should read and build all the distros" do
#     distro = Midwife::Build::Distro.find('redhat')
#     distro.name.must_equal "redhat"
#     distro.kernel.must_equal "myredkernel"
#     distro.initrd.must_equal "myredinitrd.img"
#     distro.url.must_equal "http://example.com/redhat"
#     distro.kernel_url.must_equal "http://example.com/redhat/myredkernel"
#     distro.initrd_url.must_equal "http://example.com/redhat/myredinitrd.img"

#     distro = Midwife::Build::Distro.find('centos')
#     distro.name.must_equal "centos"
#     distro.kernel.must_equal "mycentkernel"
#     distro.initrd.must_equal "mycentinitrd.img"
#     distro.url.must_equal "http://example.com/centos"
#     distro.kernel_url.must_equal "http://example.com/centos/mycentkernel"
#     distro.initrd_url.must_equal "http://example.com/centos/mycentinitrd.img"
#   end

#   it "should read and build all of the domains" do
#     domain = Midwife::Build::Domain.find('test')
#     domain.name.must_equal 'test'
#     domain = Midwife::Build::Domain.find('private')
#     domain.name.must_equal 'private'
#     domain = Midwife::Build::Domain.find('local')
#     domain.name.must_equal 'local'
#   end

#   it "should read and build all of the hosts" do
#     (1..10).to_a.each do |num|
#       host = Midwife::Build::Host.find("system#{num}.local")
#       host.name.must_equal "system#{num}.local"
#     end

#     host = Midwife::Build::Host.find('other1.private')
#     host.name.must_equal 'other1.private'

#     host = Midwife::Build::Host.find('static1.private')
#     host.name.must_equal 'static1.private'
#   end

#   it "should read and build all of the schemes" do
#     scheme = Midwife::Build::Scheme.find('default')
#     scheme.name.must_equal 'default'
#     scheme = Midwife::Build::Scheme.find('split')
#     scheme.name.must_equal 'split'
#   end
# end