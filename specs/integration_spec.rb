require File.dirname(__FILE__) + '/spec_helper'

describe "Kickstart generation with host" do
  before(:each) do
    @host = Midwife::DSL::Host.build "example.com" do
      distro "centos6" do
        url "http://localhost/centos6"
        kernel "vmlinuz"
        initrd "initrd.img"
      end

      chef "chef.example.com" do
        version           "11.4.4"
        client_name       "root"
        client_key        "./specs/files/snakeoil-root.pem"
        validator_name    "validator"
        validation_key    "./specs/files/snakeoil-validation.pem"
        encrypted_data_bag_secret "mysecret"
      end

      scheme "rootandhome" do
        partition "/" do
          size 8192
          type "ext4"
        end
        partition "/home" do
          size 1
          grow
        end
      end

      net 'eth0' do
        domain 'local' do
          netmask '255.255.255.0'
          gateway '192.168.1.1'
          nameserver '192.168.1.253'
          nameserver '192.168.1.252'
          ntpserver '192.168.1.253'
          ntpserver '192.168.1.252'
        end
        bootproto :static
        ip        '192.168.1.100'
      end
      
      template "default"

      pxemac    '00:11:22:33:44:55'
      run_list  %w{recipe[sudo] recipe[authentication] recipe[nagios] recipe[apache]}
      timezone  'America/Los_Angeles'
      selinux   :permissive
      password  'ummm'
    end
  end

  after(:each) do
    Midwife::DSL::Host.clear
  end

  %w{ RHEL5 RHEL6 RHEL7 }.each do |ver|
    it "should generate valid kickstart configurations for #{ver}" do
      skip("pending")
      ks = Midwife::Kickstart::Builder.new(@host)
    end
  end
end