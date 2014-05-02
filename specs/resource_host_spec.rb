require File.dirname(__FILE__) + '/spec_helper'

describe "Stork::Resource::Host" do
  it "must create a host" do
    Stork::Resource::Host.new.must_be_instance_of Stork::Resource::Host
  end

  it "must respond to the name method" do
    Stork::Resource::Host.new.must_respond_to :name
  end

  it "must respond to the layout accessors" do
    Stork::Resource::Host.new.must_respond_to :layout
    Stork::Resource::Host.new.must_respond_to :layout=
  end

  it "must respond to the template accessors" do
    Stork::Resource::Host.new.must_respond_to :template
    Stork::Resource::Host.new.must_respond_to :template=
  end

  it "must respond to the chef accessors" do
    Stork::Resource::Host.new.must_respond_to :chef
    Stork::Resource::Host.new.must_respond_to :chef=
  end

  it "must respond to the pxemac accessors" do
    Stork::Resource::Host.new.must_respond_to :pxemac
    Stork::Resource::Host.new.must_respond_to :pxemac=
  end

  it "must respond to the pre_snippets accessors" do
    Stork::Resource::Host.new.must_respond_to :pre_snippets
    Stork::Resource::Host.new.must_respond_to :pre_snippets=
  end

  it "must respond to the post_snippets accessors" do
    Stork::Resource::Host.new.must_respond_to :post_snippets
    Stork::Resource::Host.new.must_respond_to :post_snippets=
  end

  it "must respond to the interfaces accessors" do
    Stork::Resource::Host.new.must_respond_to :interfaces
    Stork::Resource::Host.new.must_respond_to :interfaces=
  end

  it "must respond to the distro accessors" do
    Stork::Resource::Host.new.must_respond_to :distro
    Stork::Resource::Host.new.must_respond_to :distro=
  end

  it "must respond to the run_list accessors" do
    Stork::Resource::Host.new.must_respond_to :run_list
    Stork::Resource::Host.new.must_respond_to :run_list=
  end

  it "must respond to the repos accessors" do
    Stork::Resource::Host.new.must_respond_to :repos
    Stork::Resource::Host.new.must_respond_to :repos=
  end

  # it "must raise an error if the template is not found" do
  #   proc {
  #     host = Stork::Resource::Host.build configuration, collection, "example.org" do
  #       template "invalid"
  #     end
  #   }.must_raise(SyntaxError)
  # end

  # it "must raise an error if the snippet is not found for pre" do
  #   proc {
  #     host = Stork::Resource::Host.build configuration, collection, "example.org" do
  #       pre_snippet "invalid"
  #     end
  #   }.must_raise(SyntaxError)
  # end

  # it "must raise an error if the snippet is not found for post" do
  #   proc {
  #     host = Stork::Resource::Host.build configuration, collection, "example.org" do
  #       post_snippet "invalid"
  #     end
  #   }.must_raise(SyntaxError)
  # end

  # it "must raise an error if a block is not passed to firewall" do
  #   proc {
  #     host = Stork::Resource::Host.build configuration, collection, "example.org" do
  #       firewall
  #     end
  #   }.must_raise(SyntaxError)
  # end

  # it "must raise an error if a block is not passed to password" do
  #   proc {
  #     host = Stork::Resource::Host.build configuration, collection, "example.org" do
  #       password
  #     end
  #   }.must_raise(SyntaxError)
  # end

  # it "must build inline" do
  #   ckey = "./specs/keys/snakeoil-root.pem"
  #   vkey = "./specs/keys/snakeoil-validation.pem"

  #   host = Stork::Resource::Host.build configuration, collection, "example.org" do
  #     template "default"
  #     pxemac "00:11:22:33:44:55"

  #     repo 'foo', baseurl: 'http://foo.com'

  #     distro "centos" do
  #       kernel "vmlinuz"
  #       image "initrd.img"
  #       url "http://mirror.example.com/centos"
  #     end

  #     layout "default" do
  #       clearpart
  #       zerombr
  #       part "/boot" do
  #         size 100
  #         type "ext4"
  #         primary
  #       end

  #       part "swap" do
  #         type "swap"
  #         primary
  #         recommended
  #       end

  #       part "/" do
  #         size 4096
  #         type "ext4"
  #       end

  #       part "/home" do
  #         size 1
  #         type "ext4"
  #         grow
  #       end
  #     end

  #     chef "default" do
  #       url "https://chef.example.org"
  #       version "11.6.0"
  #       client_name "root"
  #       client_key ckey
  #       validator_name "chef-validator"
  #       validation_key vkey
  #       encrypted_data_bag_secret "secretkey"
  #     end

  #     interface "eth0" do
  #       bootproto :static
  #       ip        "192.168.1.10"
  #       netmask "255.255.255.0"
  #       gateway "192.168.1.1"
  #       nameserver "192.168.1.253"
  #       nameserver "192.168.1.252"
  #     end
  #   end

  #   host.name.must_equal "example.org"
  #   host.pxemac.must_equal "00:11:22:33:44:55"
  #   host.distro.name.must_equal "centos"
  #   host.distro.kernel.must_equal "vmlinuz"
  #   host.distro.image.must_equal "initrd.img"
  #   host.distro.url.must_equal "http://mirror.example.com/centos"
  #   host.layout.clearpart.must_equal true
  #   host.layout.zerombr.must_equal true
  #   parts = host.layout.partitions
  #   parts[0].path.must_equal '/boot'
  #   parts[0].size.must_equal 100
  #   parts[0].type.must_equal "ext4"
  #   parts[0].primary.must_equal true
  #   parts[1].path.must_equal 'swap'
  #   parts[1].type.must_equal "swap"
  #   parts[1].recommended.must_equal true
  #   parts[2].path.must_equal "/"
  #   parts[2].size.must_equal 4096
  #   parts[3].path.must_equal "/home"
  #   parts[3].type.must_equal "ext4"
  #   parts[3].grow.must_equal true
  #   host.chef.url.must_equal "https://chef.example.org"
  #   host.chef.version.must_equal "11.6.0"
  #   host.chef.client_name.must_equal "root"
  #   host.chef.client_key.must_equal File.read(ckey)
  #   host.chef.validator_name.must_equal "chef-validator"
  #   host.chef.validation_key.must_equal File.read(vkey)
  #   host.chef.encrypted_data_bag_secret.must_equal "secretkey"
  #   interface = host.interfaces.first
  #   interface.device.must_equal "eth0"
  #   interface.bootproto.must_equal :static
  #   interface.ip.must_equal "192.168.1.10"
  #   interface.netmask.must_equal "255.255.255.0"
  #   interface.gateway.must_equal "192.168.1.1"
  #   interface.nameservers.must_equal ["192.168.1.253", "192.168.1.252"]
  # end

  # it "must build with collections" do
  #   ckey = "./specs/files/configs/keys/snakeoil-root.pem"
  #   vkey = "./specs/files/configs/keys/snakeoil-validation.pem"
  #   collection = Midwife::Collection.new
  #
  #   distro = Stork::Resource::Distro.build("centos") do
  #     kernel "vmlinuz"
  #     image "initrd.img"
  #     url "http://mirror.example.com/centos"
  #   end
  #
  #   layout = Stork::Resource::Layout.build("default") do
  #     clearpart
  #     zerombr
  #     part "/boot" do
  #       size 100
  #       type "ext4"
  #       primary
  #     end
  #
  #     part "swap" do
  #       type "swap"
  #       primary
  #       recommended
  #     end
  #
  #     part "/" do
  #       size 4096
  #       type "ext4"
  #     end
  #
  #     part "/home" do
  #       size 1
  #       type "ext4"
  #       grow
  #     end
  #   end
  #
  #   chef = Stork::Resource::Chef.build("default") do
  #     url "https://chef.example.org"
  #     version "11.6.0"
  #     client_name "root"
  #     client_key ckey
  #     validator_name "chef-validator"
  #     validation_key vkey
  #     encrypted_data_bag_secret "secretkey"
  #   end
  #
  #   net = Stork::Resource::Network.build("local") do
  #     netmask "255.255.255.0"
  #     gateway "192.168.1.1"
  #     nameserver "192.168.1.253"
  #     nameserver "192.168.1.252"
  #   end
  #
  #   snip = Stork::Resource::Snippet.new(File.dirname(__FILE__) + '/files/configs/snippets/noop.erb')
  #
  #   collection.distros.add(distro)
  #   collection.layouts.add(layout)
  #   collection.chefs.add(chef)
  #   collection.networks.add(net)
  #   collection.snippets.add(snip)
  #
  #   host = Stork::Resource::Host.build(collection, "example.org") do
  #     template "default"
  #     pxemac "00:11:22:33:44:55"
  #
  #     distro "centos"
  #     layout "default"
  #     chef "default"
  #
  #     pre_snippet "noop"
  #     post_snippet "noop"
  #
  #     interface "eth0" do
  #       bootproto :static
  #       ip "192.168.1.10"
  #       network "local"
  #     end
  #   end
  #
  #   host.name.must_equal "example.org"
  #   host.pxemac.must_equal "00:11:22:33:44:55"
  #   host.distro.name.must_equal "centos"
  #   host.distro.kernel.must_equal "vmlinuz"
  #   host.distro.image.must_equal "initrd.img"
  #   host.distro.url.must_equal "http://mirror.example.com/centos"
  #   host.layout.clearpart.must_equal true
  #   host.layout.zerombr.must_equal true
  #   parts = host.layout.partitions
  #   parts[0].path.must_equal '/boot'
  #   parts[0].size.must_equal 100
  #   parts[0].type.must_equal "ext4"
  #   parts[0].primary.must_equal true
  #   parts[1].path.must_equal 'swap'
  #   parts[1].type.must_equal "swap"
  #   parts[1].recommended.must_equal true
  #   parts[2].path.must_equal "/"
  #   parts[2].size.must_equal 4096
  #   parts[3].path.must_equal "/home"
  #   parts[3].type.must_equal "ext4"
  #   parts[3].grow.must_equal true
  #   host.chef.url.must_equal "https://chef.example.org"
  #   host.chef.version.must_equal "11.6.0"
  #   host.chef.client_name.must_equal "root"
  #   host.chef.client_key.must_equal File.read(ckey)
  #   host.chef.validator_name.must_equal "chef-validator"
  #   host.chef.validation_key.must_equal File.read(vkey)
  #   host.chef.encrypted_data_bag_secret.must_equal "secretkey"
  #   interface = host.interfaces.first
  #   interface.device.must_equal "eth0"
  #   interface.bootproto.must_equal "static"
  #   interface.ip.must_equal "192.168.1.10"
  #   interface.netmask.must_equal "255.255.255.0"
  #   interface.gateway.must_equal "192.168.1.1"
  #   interface.nameservers.must_equal ["192.168.1.253", "192.168.1.252"]
  #   host.post_snippets[0].name.must_equal "noop"
  #   host.post_snippets[0].content.must_equal "# Default Snippet\n"
  #   host.pre_snippets[0].name.must_equal "noop"
  #   host.pre_snippets[0].content.must_equal "# Default Snippet\n"
  # end
end
