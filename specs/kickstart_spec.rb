# option_spec.rb
require File.dirname(__FILE__) + "/spec_helper"

describe "Midwife::Kickstart" do

  context "Builder" do
    it "should render without error" do
      class StringMock
        def method_missing(sym, *args)
          "### < #{sym.to_s.upcase} > ###"
        end
      end

      class ArrayMock
        def method_missing(sym, *args)
          ["### < #{sym.to_s.upcase} > ###"]
        end
      end

      stringmock = StringMock.new
      arraymock = ArrayMock.new
      build = Midwife::Kickstart::Builder.new('default',
        host: stringmock,
        domain: arraymock,
        scheme: stringmock,
        chef: stringmock,
        post: stringmock,
        midwife: stringmock
      )
      build.render.wont_equal ""
    end
  end

  context "Bootloader" do
    it "emits the correct kickstart lines with defaults" do
      boot = Midwife::Kickstart::Bootloader.build
      boot.emit.must_equal "bootloader --location=mbr"
    end
  end

  context "Clearpart" do
    it "emits the correct kickstart lines with defaults" do
      boot = Midwife::Kickstart::Clearpart.build
      boot.emit.must_equal "clearpart --all --initlabel"
    end
  end

  context "Command" do
    it "should respond to options" do
      Midwife::Kickstart::Command.must_respond_to(:options)
      Midwife::Kickstart::Command.options.must_be_kind_of(Hash)
    end

    it "should respond to name" do
      Midwife::Kickstart::Command.must_respond_to(:name)
    end

    it "should respond to option" do
      Midwife::Kickstart::Command.must_respond_to(:option)
    end

    it "should be emit the correct output" do
      class Foo < Midwife::Kickstart::Command
        name "foo"
        option :hello, default: "world"
        option :count, default: 13, type: Integer
        option :flag, boolean: true, default: true
      end
      foo = Foo.new
      foo.emit.must_equal "foo --count=13 --flag --hello=world"

      foo.hello = "goodbye"
      foo.count = 14
      foo.flag = false
      foo.emit.must_equal "foo --count=14 --hello=goodbye"
    end

    it "should build a new command" do
      class Foo < Midwife::Kickstart::Command
        name "foo"
        option :hello, default: "world"
        option :count, default: 13, type: Integer
        option :flag, boolean: true, default: true
      end

      foo = Foo.build("bar") do
        hello "goodbye"
        count 15
        flag
      end

      foo.emit.must_equal "foo bar --count=15 --flag --hello=goodbye"
    end

    it "should raise an exception if a undefined method is encountered" do
      class Foo < Midwife::Kickstart::Command
        name "foo"
        option :hello, default: "world"
        option :count, default: 13, type: Integer
        option :flag, boolean: true, default: true
      end

      proc {
        foo = Foo.build("bar") do
          bad
        end
      }.must_raise(SyntaxError)
    end
  end

  context "Firewall" do
    it "emits the defaults" do
      fw = Midwife::Kickstart::Firewall.build('eth0')
      fw.emit.must_equal "firewall --enabled --ssh eth0"
    end

    it "emits the services" do
      fw = Midwife::Kickstart::Firewall.build('eth0') do
        ssh
        smtp
        http
        ftp
      end
      fw.emit.must_equal "firewall --enabled --ssh --smtp --http --ftp eth0"
    end

    it "disables the firewall" do
      fw = Midwife::Kickstart::Firewall.build do
        disabled
      end
      fw.emit.must_equal "firewall --disabled"
    end
  end

  context "Network" do
    before :each do
      @ifaceemit = "network --device=eth0 --bootproto=dhcp"
    end

    it "emits the correct kickstart lines with defaults" do
      iface = Midwife::Kickstart::Network.build('eth0')
      iface.emit.must_equal "#{@ifaceemit} --onboot=yes"
    end

    it "emits ip and domain info on static" do
      # skip("Waiting on domain")
      iface = Midwife::Kickstart::Network.build('eth0') do
        bootproto :static
        ip "192.168.0.10"
        netmask "255.255.255.0"
        gateway "192.168.0.1"
        nameservers ["192.168.0.252", "192.168.0.253"]
      end
      iface.emit.must_equal "network --device=eth0 --bootproto=static --ip=192.168.0.10 --netmask=255.255.255.0 --gateway=192.168.0.1 --nameserver=192.168.0.252,192.168.0.253 --onboot=yes"
    end

    it "emits with noboot" do
      iface = Midwife::Kickstart::Network.build('eth0') do
        onboot false
      end
      iface.emit.must_equal "#{@ifaceemit} --onboot=no"
    end

    it "emits with noipv4" do
      iface = Midwife::Kickstart::Network.build('eth0') do
        noipv4
      end
      iface.noipv4.must_equal true
      iface.emit.must_equal "#{@ifaceemit} --onboot=yes --noipv4"
    end

    it "emits with noipv6" do
      iface = Midwife::Kickstart::Network.build('eth0') do
        noipv6
      end
      iface.noipv6.must_equal true
      iface.emit.must_equal "#{@ifaceemit} --onboot=yes --noipv6"
    end

    it "emits with nodefroute" do
      iface = Midwife::Kickstart::Network.build('eth0') do
        nodefroute
      end
      iface.nodefroute.must_equal true
      iface.emit.must_equal "#{@ifaceemit} --onboot=yes --nodefroute"
    end

    it "emits with nodns" do
      iface = Midwife::Kickstart::Network.build('eth0') do
        nodns
      end
      iface.nodns.must_equal true
      iface.emit.must_equal "#{@ifaceemit} --onboot=yes --nodns"
    end

    it "emits with ethtool" do
      iface = Midwife::Kickstart::Network.build('eth0') do
        ethtool "autoneg off duplex full speed 100"
      end
      iface.ethtool.must_equal "autoneg off duplex full speed 100"
      iface.emit.must_equal "#{@ifaceemit} --onboot=yes --ethtool=\"autoneg off duplex full speed 100\""
    end

    it "emits with mtu" do
      iface = Midwife::Kickstart::Network.build('eth0') do
        mtu 1500
      end
      iface.mtu.must_equal 1500
      iface.emit.must_equal "#{@ifaceemit} --onboot=yes --mtu=1500"
    end
  end

  context "Option" do
    it "should set the default values" do
      opt = Midwife::Kickstart::Option.new("foo")
      
      opt.name.must_equal "foo"
      opt.required.must_equal false
      opt.default_value.must_equal nil
      opt.type.must_equal String
      opt.as.must_equal "foo"
      opt.boolean.must_equal false
    end

    it "should set values when passed" do
      opt = Midwife::Kickstart::Option.new("foo", required: true, default: 13, type: Integer, as: "bar")
      
      opt.name.must_equal "foo"
      opt.required.must_equal true
      opt.default_value.must_equal 13
      opt.type.must_equal Integer
      opt.as.must_equal "bar"
    end

    it "should set and get the value" do
      opt = Midwife::Kickstart::Option.new("foo")
      opt.value = "Hello World"
      opt.value.must_equal "Hello World"
    end

    it "should return the default value if the value has not been set" do
      opt = Midwife::Kickstart::Option.new("foo", default: "Hello World")
      opt.value.must_equal "Hello World"
    end

    it "should raise a type error if setting value to something not of the same type" do
      opt = Midwife::Kickstart::Option.new("foo")
      proc {
        opt.value = 13
      }.must_raise(TypeError)
    end

    it "should raise a type error for boolean values if not true or false" do
      opt = Midwife::Kickstart::Option.new("foo", boolean: true)
      proc {
        opt.value = 13
      }.must_raise(TypeError)
    end

    it "should emit the correct values" do
      opt = Midwife::Kickstart::Option.new("foo")
      opt.emit.must_equal ""
      opt.value = "hello"
      opt.emit.must_equal "--foo=hello"
    end

    it "should take a boolean (switch) option" do
      opt = Midwife::Kickstart::Option.new("foo", boolean: true)
      opt.value = true
      opt.emit.must_equal "--foo"

      opt = Midwife::Kickstart::Option.new("foo", boolean: true)
      opt.value = false
      opt.emit.must_equal ""
    end
  end

  context "Partition" do
    it "emits the correct kickstart lines with defaults" do
      part = Midwife::Kickstart::Partition.build('/')
      part.emit.must_equal "part / --recommended --fstype=ext4"
    end

    it "emits with size and grow" do
      part = Midwife::Kickstart::Partition.build('/') do
        grow
        size 1
      end
      part.emit.must_equal "part / --grow --size=1 --fstype=ext4"
    end

    it "emits with asprimary" do
      part = Midwife::Kickstart::Partition.build('/') do
        primary
      end
      part.emit.must_equal "part / --asprimary --recommended --fstype=ext4"
    end
  end

  context "RootPassword" do
    it "emits the default" do
      rp = Midwife::Kickstart::RootPassword.build
      rp.emit.must_equal "rootpw --lock"
    end

    it "emits a plaintext password" do
      rp = Midwife::Kickstart::RootPassword.build('password') do
        plaintext
        lock false
      end
      rp.emit.must_equal "rootpw --plaintext password"
    end

    it "emits a crypt password" do
      rp = Midwife::Kickstart::RootPassword.build('$6$cryptedpassword') do
        iscrypted
        lock false
      end
      rp.emit.must_equal "rootpw --iscrypted $6$cryptedpassword"
    end
  end

  context "Selinux" do
    it "emits defaults" do
      sel = Midwife::Kickstart::Selinux.build
      sel.emit.must_equal "selinux --disabled"
    end

    it "emits permissive" do
      sel = Midwife::Kickstart::Selinux.build { permissive }
      sel.emit.must_equal "selinux --permissive"
    end

    it "emits enforcing" do
      sel = Midwife::Kickstart::Selinux.build { enforcing }
      sel.emit.must_equal "selinux --enforcing"
    end
  end

  context "Timezone" do
    it "emits with defaults" do
      tz = Midwife::Kickstart::Timezone.build('America/Los_Angeles')
      tz.emit.must_equal "timezone America/Los_Angeles"
    end

    it "emits with utc" do
      tz = Midwife::Kickstart::Timezone.build('America/Los_Angeles') { utc }
      tz.emit.must_equal "timezone --utc America/Los_Angeles"
    end

    it "emits with nontp" do
      tz = Midwife::Kickstart::Timezone.build('America/Los_Angeles') { nontp }
      tz.emit.must_equal "timezone --nontp America/Los_Angeles"
    end

    it "emits with ntpservers" do
      tz = Midwife::Kickstart::Timezone.build('America/Los_Angeles') do
        ntpservers %w{1.time.org 2.time.org}
      end
      tz.emit.must_equal "timezone --ntpservers=1.time.org,2.time.org America/Los_Angeles"
    end
  end

  context "Url" do
    it "emits with options" do
      url = Midwife::Kickstart::Url.build do
        url "https://foo.example.com/install"
        proxy "https://a:b@bar.example.com:8000"
        noverifyssl
      end
      url.emit.must_equal "url --noverifyssl --proxy=https://a:b@bar.example.com:8000 --url=https://foo.example.com/install"
    end
  end

  context "Zerombr" do
    it "emits the correct kickstart lines with defaults" do
      boot = Midwife::Kickstart::Zerombr.build('yes')
      boot.emit.must_equal "zerombr yes"
    end
  end
end