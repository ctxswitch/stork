#!/bin/bash
# bootstrap.sh
# set -x
###############################################################################
# Install and start ntp
###############################################################################
yum -y install ntp
ntpdate pool.ntp.org
/etc/init.d/ntpd start && chkconfig ntpd on

###############################################################################
# Install tftp and configure it for PXE boot.
###############################################################################
yum -y install syslinux-tftpboot tftp-server
cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/.
cp /usr/share/syslinux/menu.c32 /var/lib/tftpboot/.
mkdir /var/lib/tftpboot/pxelinux.cfg
mkdir /var/lib/tftpboot/distros
sed -i -re 's/(\s+disable\s+=) yes/\1 no/' /etc/xinetd.d/tftp
service xinetd start && chkconfig xinetd on
# Put the default in there.
cat > /var/lib/tftpboot/pxelinux.cfg/default << 'EOF'
DEFAULT local
PROMPT 0
TIMEOUT 0
TOTALTIMEOUT 0
ONTIMEOUT local
LABEL local
        LOCALBOOT -1
EOF

# Download a couple of netboot distros
MIRROR5="http://mirror.centos.org/centos-5/5.10/os/x86_64/images/pxeboot"
MIRROR6="http://mirror.centos.org/centos-6/6.5/os/x86_64/images/pxeboot"
pushd /var/lib/tftpboot/distros
echo "Downloading a few pxeboot kernels and images"
curl -s $MIRROR5/initrd.img > centos-5.10-initrd.img
curl -s $MIRROR5/vmlinuz > centos-5.10-vmlinuz
curl -s $MIRROR6/initrd.img > centos-6.5-initrd.img
curl -s $MIRROR6/vmlinuz > centos-6.5-vmlinuz
popd

###############################################################################
# Install dhcp. and configure it.
###############################################################################
yum -y install dhcp
cat > /etc/dhcp/dhcpd.conf << 'EOF'
default-lease-time 600;
max-lease-time 7200;
authoritative;
log-facility local7;

subnet 10.10.1.0 netmask 255.255.255.0 {
  range 10.10.1.120 10.10.1.200;
  allow booting;
  allow bootp;
  next-server 10.10.1.10;
  filename "pxelinux.0";
  option domain-name "vbox.local";
  option domain-name-servers 10.10.1.10;
  option routers 10.10.1.10;
  option broadcast-address 10.10.1.255;
  host head.vbox.local {
    option host-name "head";
    option domain-name "vbox.local";
    ddns-hostname "head";
    ddns-domainname "vbox.local";
    hardware ethernet 02:16:3f:c3:00:02;
    fixed-address 10.10.1.101;
  }
  host node-101.vbox.local {
    option host-name "node-101";
    option domain-name "vbox.local";
    ddns-hostname "node-101";
    ddns-domainname "vbox.local";
    hardware ethernet 02:16:3f:c3:01:01;
    fixed-address 10.10.1.101;
  }
  host node-102.vbox.local {
    option host-name "node-102";
    option domain-name "vbox.local";
    ddns-hostname "node-102";
    ddns-domainname "vbox.local";
    hardware ethernet 02:16:3f:c3:01:02;
    fixed-address 10.10.1.102;
  }
  host node-103.vbox.local {
    option host-name "node-103";
    option domain-name "vbox.local";
    ddns-hostname "node-103";
    ddns-domainname "vbox.local";
    hardware ethernet 02:16:3f:c3:01:03;
    fixed-address 10.10.1.103;
  }
}
EOF
/etc/init.d/dhcpd start && chkconfig dhcpd on

###############################################################################
# Install DNS and configure it and make some network adjustments.
###############################################################################
yum -y install bind bind-utils

cat > /etc/named.conf << 'EOF'
options {
    listen-on port 53 { 127.0.0.1; 10.10.1.10; };
    directory "/var/named";
    version "0.nunya";
    forwarders { 10.0.2.3; };
    allow-transfer { none; };
    allow-query { localhost; };
    statistics-file "data/named_stats.txt";
    memstatistics-file "data/named_mem_stats.txt";
    dnssec-enable no;
    dnssec-validation no;
};

logging {
    channel default_debug {
        file "data/named.run";
        severity dynamic;
    };
};

zone "." IN {
    type hint;
    file "named.ca";
};

zone "vbox.local" IN {
    type master;
    file "vbox.local.zone";
    allow-update { none; };
};

zone "1.10.10.in-addr.arpa" IN {
    type master;
    file "vbox.local.db";
    allow-update { none; };
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
EOF

cat > /var/named/vbox.local.zone << 'EOF'
$TTL    1D;
$ORIGIN vbox.local.
@               IN      SOA     @   root.vbox.local. (
                        2014062501 ; serial
                        3h ; refresh
                        1w ; retry
                        1w ; expire
                        3h) ; min
@           1D  IN  NS      stork
stork       1D  IN  A       10.10.1.10
chef        1D  IN  CNAME   stork
head        1D  IN  A       10.10.1.100
node-101    1D  IN  A       10.10.1.101
node-102    1D  IN  A       10.10.1.102
node-103    1D  IN  A       10.10.1.103
EOF

cat > /var/named/vbox.local.db << 'EOF'
$TTL    1D;
@       IN      SOA     stork.vbox.local.   root.vbox.local. (
                        2014062501 ; serial
                        3H ; refresh
                        15 ; retry
                        1w ; expire
                        3h) ; min
                NS      stork.vbox.local.
10              PTR     stork.vbox.local.
100             PTR     head.vbox.local.
101             PTR     node-101.vbox.local.
102             PTR     node-102.vbox.local.
103             PTR     node-103.vbox.local.
EOF

/etc/init.d/named start && chkconfig named on

###############################################################################
# Create ssh keys
###############################################################################
pushd ~vagrant/.ssh
ssh-keygen -t rsa -N "" -f id_rsa -N ""
chown vagrant:vagrant id_rsa*
popd

###############################################################################
# Chef setup with chef server and a few basic cookbooks for testing.
###############################################################################
pushd /tmp
wget https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-server-11.0.12-1.el6.x86_64.rpm
yum -y localinstall chef-server-11.0.12-1.el6.x86_64.rpm
chef-server-ctl reconfigure
wget https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-11.12.8-2.el6.x86_64.rpm
yum -y localinstall chef-11.12.8-2.el6.x86_64.rpm
popd

# Just utilize the admin user that is already created
pushd /root
mkdir .chef
cat > .chef/knife.rb << 'EOF'
log_level                :info
log_location             STDOUT
node_name                'admin'
client_key               '/etc/chef-server/admin.pem'
validation_client_name   'chef-validator'
validation_key           '/etc/chef-server/chef-validator.pem'
chef_server_url          'https://stork.vbox.local:443'
syntax_check_cache_path  '/root/.chef/syntax_check_cache'
EOF
popd

###############################################################################
# Set up EPEL and a few tools
###############################################################################
pushd /tmp
wget http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
yum -y localinstall epel-release-6-8.noarch.rpm
yum -y install git sqlite-devel
popd

###############################################################################
# RVM setup and Ruby 2.0.0 installation
###############################################################################
curl -sSL https://get.rvm.io | bash -s stable
source /usr/local/rvm/scripts/rvm
type rvm | head -1
rvm install 2.0.0

###############################################################################
# Install and start stork
###############################################################################
pushd /mnt/stork
rvm use 2.0.0@stork --create
su vagrant -c 'rake build'
gem install pkg/*.gem --no-rdoc --no-ri
popd

# Create the configuration
mkdir /etc/stork
pushd /etc/stork

cat > /etc/stork/config.rb << 'EOF'
# Stork configuration file"
path                    "/etc/stork"
bundle_path             "/etc/stork/bundles"
authorized_keys_file    "/etc/stork/authorized_keys"
pxe_path                "/var/lib/tftpboot/pxelinux.cfg"
log_file                "/var/log/stork.log"
pid_file                "/var/log/stork.pid"
server                  "stork.vbox.local"
port                    5000
bind                    "0.0.0.0"
timezone                "America/Los_Angeles"
EOF

# Create the authorized keys file
cat /home/vagrant/.ssh/id_rsa.pub > /etc/stork/authorized_keys
# Get the example bundles
git clone https://github.com/rlyon/stork-bundle.git bundles

cat > /usr/bin/stork_start << 'EOF'
#!/bin/bash
source /usr/local/rvm/scripts/rvm
rvm use 2.0.0@stork
storkctl start
EOF
chmod 755 /usr/bin/stork_start

cat > /usr/bin/stork_update << 'EOF'
#!/bin/bash
source /usr/local/rvm/scripts/rvm
rvm use 2.0.0@stork
cd /mnt/stork
rake install
EOF
chmod 755 /usr/bin/stork_update

mkdir ~vagrant/.stork
ln -s /etc/stork/config.rb ~vagrant/.stork/client.rb
chown -R vagrant:vagrant ~vagrant/.stork

# Make sure that RVM uses the system ruby as default.
rvm reset



###############################################################################
# Networking adjustments
###############################################################################
echo "PEERDNS=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
cat > /etc/resolv.conf << 'EOF'
options single-request-reopen
nameserver 127.0.0.1
EOF

/etc/init.d/network restart

###############################################################################
# Turn on NATing so we can use this as the gateway for our isolated test vms
###############################################################################
sed -i -re 's/(net.ipv4.ip_forward\s+=) 0/\1 1/' /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
/etc/init.d/iptables start
iptables -A FORWARD -i eth1 -j ACCEPT
iptables -A FORWARD -o eth1 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
/etc/init.d/iptables save

###############################################################################
# Since we now have a TFTP, SysLinux, DHCP, DNS, Nating and Stork shared on a
# mounted directory, we can set up a simple vbox config which will enable us to
# go through the entire install process on a laptop. 
###############################################################################
