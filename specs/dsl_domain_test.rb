# require File.dirname(__FILE__) + '/spec_helper'

# describe "Midwife::Build::Domain" do
#   it "emits the correct kickstart lines with defaults" do
#     domain = Midwife::Build::Domain.build('test')
#     domain.emit.must_equal ""
#   end

#   it "emits with the rest" do
#     domain = Midwife::Build::Domain.build 'test' do
#       netmask "255.255.255.0"
#       gateway "192.168.0.1"
#       nameserver "192.168.0.1"
#     end
#     domain.emit.must_equal "--netmask=255.255.255.0 --gateway=192.168.0.1 --nameserver=192.168.0.1"
#   end

#   it "emits with the multiple namservers" do
#     domain = Midwife::Build::Domain.build 'test' do
#       netmask "255.255.255.0"
#       gateway "192.168.0.1"
#       nameserver "192.168.0.254"
#       nameserver "192.168.0.253"
#     end
#     domain.emit.must_equal "--netmask=255.255.255.0 --gateway=192.168.0.1 --nameserver=192.168.0.254,192.168.0.253"
#   end
# end