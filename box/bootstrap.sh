#!/bin/bash
# bootstrap.sh
# set -x
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
  range 10.10.1.100 10.10.1.200;
  allow booting;
  allow bootp;
  next-server 10.10.1.10;
  filename "pxelinux.0";
  option domain-name "vbox.local";
  option domain-name-servers 10.10.1.10;
  option routers 10.10.1.10;
  option broadcast-address 10.10.1.255;
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
    forward only;
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
@       IN      SOA     @   root.vbox.local. (
                        2014062501 ; serial
                        3h ; refresh
                        1w ; retry
                        1w ; expire
                        3h) ; min
@       1D  IN  NS      stork
stork   1D  IN  A       10.10.1.10
chef    1D  IN  CNAME   stork
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
# Chef setup with chef-zero and a few basic cookbooks for testing.
###############################################################################

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
gem install pkg/*.gem
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
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
/etc/init.d/iptables save

###############################################################################
# Since we now have a TFTP, SysLinux, DHCP, DNS, Nating and Stork shared on a
# mounted directory, we can set up a simple vbox config which will enable us to
# go through the entire install process on a laptop. 
###############################################################################
