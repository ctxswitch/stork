require File.dirname(__FILE__) + '/spec_helper'

describe "Midwife::DSL" do
  context "Base" do
    before(:each) do
      class FooBar
        include Midwife::DSL::Base
        integer :foo
        integer :bar
        integer :baz
      end
    end

    # after(:each) do
    #   FooBar.clear
    # end

    it "should respond to dynamic attributes" do
      @obj = FooBar.new("me")
      @obj.must_respond_to :foo
      @obj.must_respond_to :bar
      @obj.must_respond_to :baz
      @obj.must_respond_to :foo=
      @obj.must_respond_to :bar=
      @obj.must_respond_to :baz=
    end

    it "should set attributes" do
      @obj = FooBar.new("me")
      @obj.foo = 1
      @obj.bar = 2
      @obj.baz = 3
      @obj.foo.must_equal 1
      @obj.bar.must_equal 2
      @obj.baz.must_equal 3
    end

    it "should build an object" do
      @obj = FooBar.build "me" do
        foo 1
        bar 2
        baz 3
      end
      @obj.foo.must_equal 1
      @obj.bar.must_equal 2
      @obj.baz.must_equal 3
    end

    it "should find an object" do
      FooBar.build "me" do
        foo 1
        bar 2
        baz 3
      end

      FooBar.build "myself" do
        foo 4
        bar 5
        baz 6
      end

      FooBar.build "i" do
        foo 7
        bar 8
        baz 9
      end

      @obj = FooBar.find('myself')
      @obj.foo.must_equal 4
      @obj.bar.must_equal 5
      @obj.baz.must_equal 6
    end

    it "should raise an error on invalid attribute" do
      proc {
        FooBar.build "me" do
          invalid true
        end
      }.must_raise(SyntaxError)
    end
  end

  context "Host" do
    after(:each) do
      Midwife::DSL.constants.select { |c| 
        Class === Midwife::DSL.const_get(c) 
      }.each { |c|
        Midwife::DSL.const_get(c).clear
      }
    end

    it "should set all parameters and attributes inline" do
      @host = Midwife::DSL::Host.build "example.com" do
        distro "centos6" do
          url "http://localhost/centos6"
          kernel "vmlinuz"
          initrd "initrd.img"
        end

        chef "chef.example.com" do
          version           "11.4.4"
          client_name       "root"
          client_key        "client.key"
          validator_name    "validator"
          validation_key    "validation.key"
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

      # puts @host.inspect
      @host.wont_equal nil
      @host.distro.must_be_instance_of Midwife::DSL::Distro
      Midwife::DSL::Distro.find('centos6').must_be_nil
      @host.chef.must_be_instance_of Midwife::DSL::Chef
      Midwife::DSL::Chef.find('chef.example.com').must_be_nil
      @host.scheme.must_be_instance_of Midwife::DSL::Scheme
      Midwife::DSL::Scheme.find('rootandhome').must_be_nil
      @host.scheme.partitions.must_be_instance_of Array
      @host.scheme.partitions.length.must_equal 2
      @host.nets.must_be_instance_of Array
      @host.nets.first.domain.must_be_instance_of Midwife::DSL::Domain
    end

    it "should set all parameters and attributes inline" do
      @distro = Midwife::DSL::Distro.build('centos6') do
        url "http://localhost/centos6"
        kernel "vmlinuz"
        initrd "initrd.img"
      end

      @chef = Midwife::DSL::Chef.build('chef.example.com') do
        version           "11.4.4"
        client_name       "root"
        client_key        "client.key"
        validator_name    "validator"
        validation_key    "validation.key"
        encrypted_data_bag_secret "mysecret"
      end

      @scheme = Midwife::DSL::Scheme.build('rootandhome') do
        partition "/" do
          size 8192
          type "ext4"
        end
        partition "/home" do
          size 1
          grow
        end
      end

      @domain = Midwife::DSL::Domain.build('local') do
        netmask '255.255.255.0'
        gateway '192.168.1.1'
        nameserver '192.168.1.253'
        nameserver '192.168.1.252'
        ntpserver '192.168.1.253'
        ntpserver '192.168.1.252'
      end

      @host = Midwife::DSL::Host.build "example.com" do
        distro "centos6"
        chef "chef.example.com"
        scheme "rootandhome"

        net 'eth0' do
          domain 'local'
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

      # puts @host.inspect
      @host.wont_equal nil
      @host.distro.must_be_instance_of Midwife::DSL::Distro
      Midwife::DSL::Distro.find('centos6').must_equal @distro
      @host.chef.must_be_instance_of Midwife::DSL::Chef
      Midwife::DSL::Chef.find('chef.example.com').must_equal @chef
      @host.scheme.must_be_instance_of Midwife::DSL::Scheme
      Midwife::DSL::Scheme.find('rootandhome').must_equal @scheme
      # puts @host.scheme.inspect
      # puts @scheme.inspect
      @host.scheme.partitions.must_be_instance_of Array
      @host.scheme.partitions.length.must_equal 2
      @host.nets.must_be_instance_of Array
      @host.nets.first.domain.must_equal @domain
    end
  end
end