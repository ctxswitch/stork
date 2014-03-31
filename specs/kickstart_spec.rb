require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::Kickstart" do
  before(:each) do
    @host = Midwife::DSL::Host.build Midwife::Collection.new, "example.org" do
      template "mytemplate"
      pxemac "00:11:22:33:44:55"

      firewall do
        trusted 'eth0'
        allow '32:tcp'
      end

      distro "centos" do
        kernel "vmlinuz"
        image "initrd.img"
        url "http://mirror.example.com/centos"
      end

      layout "default" do
        clearpart
        zerombr
        part "/boot" do
          size 100
          type "ext4"
          primary
        end

        part "swap" do
          type "swap"
          primary
          recommended
        end

        part "/" do
          size 4096
          type "ext4"
        end

        part "pv.01" do
          size 1
          grow
        end

        volume_group "vg", part: "pv.01" do
          logical_volume "lv_home" do
            path "/home"
            size 1
            grow
          end
        end
      end

      chef "default" do
        url "https://chef.example.org"
        version "11.6.0"
        client_name "root"
        client_key File.dirname(__FILE__) + "/files/configs/keys/snakeoil-root.pem"
        validator_name "chef-validator"
        validation_key File.dirname(__FILE__) + "/files/configs/keys/snakeoil-validation.pem"
        encrypted_data_bag_secret "secretkey"
      end

      interface "eth0" do
        bootproto :static
        ip "192.168.1.10"
        netmask "255.255.255.0"
        gateway "192.168.1.1"
        nameserver "192.168.1.253"
        nameserver "192.168.1.252"
      end
    end
  end

  %w{ RHEL5 RHEL6 RHEL7 }.each do |ver|
    it "should generate valid kickstart configurations for #{ver}" do
      # skip("pending")

      ksvalidate = File.join(File.dirname(__FILE__), 'scripts', 'ksvalidate.sh')
      testpath = File.join(File.dirname(__FILE__), 'tmp')
      kspath = File.join(File.dirname(__FILE__), 'tmp', 'output.ks')

      template = File.dirname(__FILE__) + "/files/configs/templates/default.ks.erb"
      ks = Midwife::Kickstart.new(template, @host)

      file = File.open('specs/tmp/output.ks', 'w')
      file.write(ks.render)
      file.close

      Open3.popen3("#{ksvalidate} #{testpath} #{kspath} #{ver}") do |stdin, stdout, stderr, wait_thr|
        exit_status = wait_thr.value.to_i
        output = (stdout.readlines + stderr.readlines).join
        assert_equal(0, exit_status, output)
      end

      File.unlink('specs/tmp/output.ks')
    end
  end
end
