echo "Installing Chef"

bash -c '
exists() {
  if command -v $1 &>/dev/null
  then
    return 0
  else
    return 1
  fi
}

install_sh="https://www.opscode.com/chef/install.sh"
version_string="-v 11.6.0"
if ! exists /usr/bin/chef-client; then
  if exists wget; then
    bash <(wget ${install_sh} -O -) ${version_string}
  elif exists curl; then
    bash <(curl -L ${install_sh}) ${version_string}
  else
    echo "Neither wget nor curl found. Please install one and try again." >&2
    exit 1
  fi
fi


cat > /etc/chef/encrypted_data_bag_secret << 'EOF'
secretkey
EOF
chmod 0600 /etc/chef/encrypted_data_bag_secret


mkdir -p /etc/chef

cat > /etc/chef/validation.pem << 'EOF'
-----BEGIN RSA PRIVATE KEY-----
MIIEoAIBAAKCAQEAwxUcd7UHY6O4bnxtuAq6xVbmdOlhpsy78bZVyG46I2bpXLDy
Vqa458uJqovtsFr65/lKK8LVvz3gSHP2UXC6+afDnJoRrbBrPu+NH03lVyLmV0kP
GmDS7+4767ywK/yZW187sJ6HOCv9ximoW9Bs3t0QbMcGHOilppjSbWNNPiqDL9qk
9feAq1ncvLenhc7bzVN8/EgEuAqV5J65dkf9LDbtRlzl4cZUagxgxAZnt4wL/je6
tqpiM+u0K85QJLsUJ8Uqq/ZCywAMKmGxYVuFUPmVfapS/y6LXEeT/RReltjL+zAD
qrEdaiqYvOttMYk3kDWiXuLXvbwhlJXUJQAwxQIDAQABAoIBAHDz9kmxfZfJoe4H
CZg4TjAYwtMKlkn33RJ1GnI0sGDzI0dSBN77JbDAfvNKldM4unI6OyHfa9eRQh1x
VzuMZBZNdstjwbypm08TcMihV5r+UBRV7vK9ASV+8R7rX634Ues/1tXK1ExH3GYy
lJKkuYTIxsvU6MswQUmWzrAbgQvumT55mguR0eT2KzUzP7SCcliWUr9xDfahsmsg
tavhR9FF9uCiYBm9y2/4JFA5Cb1r1YPeQ/VFMiJP0vG4AmiipmmkiYQEFzT7UHG2
g9X1zv9tDX/DI9Pmno0dAohQKRaycN7k9tXWuHU9xTJiHqUQ47A5TuGOiK7O5mLw
rBQ+Z4ECgYEA+PNuxtwziG6qchhOw+lX6jdFPiFBobW+9xcdFx/Btiq3HW9UT/CD
gARzJknzvYQSA7iK5yLp9dY8ZnAVfmTFvfTGdObQ2XlP7peJkb6JWtLECGoOzrRR
peG3+ij839L1fwunZGvOzcBDcloW626L84nfnj04dIWl4/bu/NoPRfECgYEAyJsz
9pGcJ+bsl5Bv7SASrCiOfHO5luQgrdCTPKbeOdHRJVOhsp0snMtdUXdaCtV2GX22
YW5CvckB26QJGdnwPiqcB2liRPnAYNeSBIoGAzhv8SJWXl7XwKiWieJuFTfgLFB+
lc8H/qcfMkI8aJAAwVo24XLzVA677Mf8NBOytBUCgYBHuctW3Ca0zj2pdbtr0pUT
1CzNA8PnFXgZtL0a5nlnRNNRVbwS9BbPEXkjtPbWyXBvRgIvKe4CeGEamnx22A3o
9tce40mU/tC6y0pFhYIJeuQkEHqHr4g+pNPe7WQ+EIfOvMrTsgP5X8WO8snbtxP3
bOfSrYzQdZkgHwsoKqNv4QJ/WuX4pcFVAL+idQr9rHTcASZfagUGE1lLdXcNQG5c
Q9bO7hr3KfgOPv3nSwLJyh7vZJ2SBpPvqg9qyBuMBCq8sW6dRL57yMViZn9Hqsbf
8pWgI6Nrf1d6a9H4ZII1X2fyLCJNOZSWCs2vVRauSLL3pKU8OOvdVjlW7fOwU+iZ
EQKBgFGOottZB3OUEkHVfbw39ERf1Saqc2oOfw8YM9H0TIhCJvTTSlhaL6OYqEig
I3z0yoLGTD/0e7DXjC2kQyf+9LTMwcodC6MbwZ/cncDkebFLZ1DDig7+s0WoAjfI
Kl/ogSogT0HuY/6VcRjkvccDN7aZvLDXrS9N7EwqhjojsIl6
-----END RSA PRIVATE KEY-----

EOF
chmod 0644 /etc/chef/validation.pem

cat > /etc/chef/client.rb << 'EOF'
log_level              :auto
log_location           STDOUT
chef_server_url        'https://chef.example.org'
validation_client_name 'chef-validator'

EOF
chmod 644 /etc/chef/client.rb

echo "Setting up knife"
mkdir /root/.chef
chmod 700 /root/.chef

cat > /root/.chef/knife.rb << 'EOF'
log_level                :info
log_location             STDOUT
node_name                'root'
client_key               '/root/.chef/root.pem'
validation_client_name   'chef-validator'
validation_key           '/etc/chef/validation.pem'
chef_server_url          'https://chef.example.org'
cache_type               'BasicFile'
cache_options( :path => '/root/.chef/checksums' )

EOF
chmod 600 /root/.chef/knife.rb

cat > /root/.chef/root.pem << 'EOF'
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEA5OPAyH1UC88Z8L8m+AnXgNQvz3qFOXjtZnHjAm2h4H+RKPYZ
J2YdIuvrWZC7XReRtNqzlVoKSj0DglKlng6aRHm0mlZevqm34WOe9z2r1AFUb0gh
t+JfRk/uTNWMBZhGvrzJmUFhmqfFvyEioUMKLO+lu54GoLgs9KsgBCXcYpDABME7
xK6uLjWcyD7pr1Cpx2BbhuO2P1zNXi527MEhQTzC1A4Yt/KXdR/rWLBRRT1+0Bzo
NbdM0NdGFZxJ+AlEfVIffSpNwjQAUS7vHlfPhjhkTBLVHLgTXx0QtN2LwPIhuMUi
unErkxTqFMelLe83XB1TYWfZPYHuA2OZ2vj6bQIDAQABAoIBAGyMNhjelsUi6kJp
5Kkswa6u8h2LFTM0TiGPUQENzP8SgFzUmQk+PAMbrvlC0hhL3SXPseraUJb0aH2d
hD1432Ap96RZ4YS6KCIThIfsD1jzaH99zb/O8y/9KB34B/d/R82c6l5ry0X02qrR
pAKmMGUvIYHgZ3RA49EEdqKA8gsrhKY0o+LtW3naESvD2waFH+mbJI5jBTJyAgQ+
r24uclBtB7VmrrBLJ+V32Njtee8e7FG9Xs3lyTAL60ipp7WZBGp94Y9TiBHoQIUh
crp0h5o3KMUZJTA6tChLMLlOEjhSU1+LTL8yyjf345X6XL0/8P4nBP1YedSJt8rs
ZY39/AECgYEA+uziOjHbT7mTMu/tRwsG5Sc3ioJqBsa8tAQxVfMicRtBDq/F9uRX
GxJ+zBwDpVdLQjVD5zCjWc43nR/wbsjtE6/8yfjLntApWPUssuQAd7xDlZPIEIpD
kcezATWCzy+poCJhp4wH5ikAGuMBOceAX0pqj2pgdmwOlb2/D74Wlc0CgYEA6YTI
t3Ihuws5OJLj/zQzT5uFi41XdOlxeZJjf6AWN3BiKyCJ/i+lkPBvtw0tq11NAs9a
BVeKPMOWJM2y1oL838n0LBeq/oBOHBR/PPyJzRdkeVn7NuM+G24rc9FWSumtGLvk
uxQOp5MM32wK7WnBSt98kwkJ9nJFDR03BNrDVyECgYAXtSnqtasy7SWrOmAAxlnw
bLQisg+ydDSADaVbqY0ngpuy94iMuyY/uI+iWUM+6/CAYOf5f+7vHTzD67CbxwAf
TBFmQ8t5RdGiRgfjHwesSG1aRIwyg92+eE/BXXzudmJgbt8rJV/ZryYDZE9JVkAa
wL0wr6xNhAgcvcC/jAY2QQKBgADjIUQZKemlBEWjwTwB/cPqqlo6Yj+ud2Dn3nro
p8z0H1tcl0mg8rcXQsVmRmslQpqlIQluKLdMYvCm22wXOVC8WrIkMOEgqatPpKAd
sYRW92nCnsK5oE3IYF/jRrmoI6E5bYgMbnXSiDT9GxmF0lcvfDCu0xvdmUeQedoJ
3r4hAoGAJ4AzBoxBnsLSkY0Yjk3d3Disa74KvaEqJo2SUxIgqNuVkST06lBOTkJV
T3Alfl5wmACNES6YZYRouF22GByc92JZusQYSA+orrDeyvmA/nBZ2mduNaRt4fWE
In0hofU8eFN2YObs/mbUyg24dmsWLjlBitd4y72kASjlwWCZ3Ls=
-----END RSA PRIVATE KEY-----

EOF
chmod 600 /root/.chef/root.pem

echo "Reregistering client"
knife client reregister coolsystem.private -f /etc/chef/client.pem --config /root/.chef/knife.rb
echo "Getting rid of the root pem"
rm /root/.chef/root.pem

cat > /etc/chef/first-boot.json << 'EOF'
{"run_list":["role[one]","recipe[two]"]}
EOF
chmod 644 /etc/chef/first-boot.json

/usr/bin/chef-client -j /etc/chef/first-boot.json
chkconfig chef-client on
'
