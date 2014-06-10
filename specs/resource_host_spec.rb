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

  it "must return a hash with hashify" do
    host = collection.hosts.get("server.example.org")
    hash = {   
      'name' => 'server.example.org', 
      'distro' => 'centos', 
      'template' => 'default', 
      'chef' => 'default', 
      'layout' => {
        'partitions' => [
          { 
            'path' => '/boot',
            'size' => 100,
            'type' => 'ext4',
            'primary' => true,
            'grow' => false,
            'recommended' => false
          },
          { 
            'path' => 'swap',
            'size' => 1,
            'type' => 'swap',
            'primary' => true, 
            'grow' => false,
            'recommended' => true
          }, 
          { 
            'path' => '/',
            'size' => 4096,
            'type' => 'ext4',
            'primary' => false,
            'grow' => false,
            'recommended' => false
          },
          { 
            'path' => 'pv.01',
            'size' => 1,
            'type' => 'ext4',
            'primary' => false,
            'grow' => true,
            'recommended' => false
          }
        ],
        'volume_groups' => [
          { 
            'partition' => 'pv.01',
            'logical_volumes' => [
              { 
                'path' => '/home',
                'size' => 1,
                'type' => 'ext4',
                'primary' => nil,
                'grow' => true,
                'recommended' => false
              }
            ]
          }
        ]
      },
      'interfaces' => [
        { 
          'ip' => '99.99.1.8',
          'bootproto' => :static,
          'netmask' => '255.255.255.0',
          'gateway' => nil,
          'nameservers' => [],
          'search_paths' => []
        },
        { 
          'ip' => '192.168.1.10',
          'bootproto' => :static,
          'netmask' => '255.255.255.0',
          'gateway' => '192.168.1.1',
          'nameservers' => ['192.168.1.253', '192.168.1.252'],
          'search_paths' => []
        }
      ],
      'pre_snippets' => ['setup'],
      'post_snippets' => [
        'ntp',
        'resolv-conf',
        'chef-bootstrap',
        'chef-reconfigure',
        'notify'
      ],
      'repos' => ['whamcloud-client'],
      'run_list' => ['role[base]', 'recipe[apache]'], 
      'packages' => [
        '@core',
        'curl',
        'openssh-clients',
        'openssh-server',
        'finger',
        'pciutils',
        'yum',
        'at',
        'acpid',
        'vixie-cron',
        'cronie-noanacron',
        'crontabs',
        'logrotate',
        'ntp',
        'ntpdate',
        'tmpwatch',
        'rsync',
        'mailx',
        'which',
        'wget',
        'man',
        'foo'
      ], 
      'timezone' => 'America/Los_Angeles', 
      'selinux' => 'enforcing'
    }
    host.hashify.must_equal hash
  end
end
