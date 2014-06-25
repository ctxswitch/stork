#!/bin/sh
# bootstrap.sh
sudo su -
###############################################################################
# Install tftp and configure it for PXE boot.
###############################################################################
yum install syslinux-tftpboot tftp-server
cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/.
cp /usr/share/syslinux/menu.c32 /var/lib/tftpboot/.
mkdir /var/lib/tftpboot/pxelinux.cfg
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

###############################################################################
# Install dhcp. and configure it.
###############################################################################
yum install dhcp
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
  option domain-name "vbox";
  option domain-name-servers 10.10.1.10;
  option routers 10.10.1.10;
  option broadcast-address 10.10.1.255;
}
EOF
/etc/init.d/dhcpd start && chkconfig dhcpd on

###############################################################################
# Install DNS and configure it and make some network adjustments.
###############################################################################
yum install bind

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

zone "vbox" IN {
    type master;
    file "vbox.zone";
    allow-update { none; };
};

zone "1.10.10.in-addr.arpa" IN {
    type master;
    file "vbox.db";
    allow-update { none; };
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
EOF

cat > /var/named/vbox.zone << 'EOF'
$TTL    1D;
$ORIGIN vbox.
@       IN      SOA     @   root.vbox. (
                        2014062501 ; serial
                        3h ; refresh
                        1w ; retry
                        1w ; expire
                        3h) ; min
@       1D  IN  NS      stork
stork   1D  IN  A       10.10.1.10
chef    1D  IN  CNAME   stork
EOF

cat > /var/named/vbox.db << 'EOF'
$TTL    1D;
@       IN      SOA     stork.vbox.   root.vbox. (
                        2014062501 ; serial
                        3H ; refresh
                        15 ; retry
                        1w ; expire
                        3h) ; min
                NS      stork.vbox.
10              PTR     stork.vbox.
EOF

echo "PEERDNS=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
cat > /etc/resolv.conf << 'EOF'
options single-request-reopen
nameserver 127.0.0.1
EOF
/etc/init.d/network restart
/etc/init.d/named start && chkconfig named on

###############################################################################
# Turn on NATing so we can use this as the gateway
###############################################################################
sed -i -re 's/(net.ipv4.ip_forward\s+=) 0/\1 1/' /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
/etc/init.d/iptables start
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
/etc/init.d/iptables save

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
# Since we now have a TFTP, SysLinux, DHCP, DNS, Nating and Stork shared on a
# mounted directory, we can set up a simple vbox config which will enable us to
# go through the entire install process on a laptop. 
###############################################################################
