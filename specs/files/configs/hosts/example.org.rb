distro "centos" do
  kernel "vmlinuz"
  image "initrd.img"
  url "http://mirror.example.com/centos"
end

chef "default" do
  url "https://chef.example.org"
  version "11.6.0"
  client_name "root"
  client_key File.dirname(__FILE__) + "/specs/files/configs/keys/snakeoil-root.pem"
  validator_name "chef-validator"
  validation_key File.dirname(__FILE__) + "/specs/files/configs/keys/snakeoil-validation.pem"
  encrypted_data_bag_secret "secretkey"
end

network "org" do
  netmask "255.255.255.0"
  gateway "99.99.1.1"
  nameserver "99.99.1.253"
  nameserver "99.99.1.252"
end

network "local" do
  netmask "255.255.255.0"
  gateway "192,168.1.1"
  nameserver "192,168.1.253"
  nameserver "192,168.1.252"
end

layout "home" do
  clearpart
  zerombr
  part "/boot" do
    size 100
    type "ext4"
    primary
  end

  part "swap" do
    size 0
    type "swap"
    primary
  end

  part "/" do
    size 4096
    type "ext4"
  end

  part "pv.01" do
    size 1
    grow
  end

  # autofind the first pv if not specified?
  volume_group "vg", part: "pv.01" do
    logical_volume "lv_home" do
      path "/home"
      size 1
      grow
    end
  end
end

# Config for example.org
host "example.org" do
  template    "default"
  chef        "default"
  pxemac      "00:11:22:33:44:55"
  layout      "home"
  distro      "centos"


  interface "eth0" do
    bootproto :static
    ip        "99.99.1.8"
    network   "org"
  end

  interface "eth1" do
    bootproto :static
    ip        "192.168.1.10"
    network   "local"
  end

  pre_snippet    "setup"
  post_snippet   "ntp"
  post_snippet   "chef-bootstrap"
end


# OR

# hosts=[
#   [10, "00:11:22:33:44:01"],
#   [11, "00:11:22:33:44:02"],
#   [12, "00:11:22:33:44:03"],
#   [13, "00:11:22:33:44:04"],
#   [14, "00:11:22:33:44:05"],
#   [15, "00:11:22:33:44:06"],
#   [16, "00:11:22:33:44:07"],
#   [17, "00:11:22:33:44:08"],
#   [18, "00:11:22:33:44:09"],
#   [19, "00:11:22:33:44:10"]
# ]

# hosts.each do |octet, mac|
#   host "n0#{octet}.example.org" do
#     template    "default"
#     chef        "default"
#     pxemac      mac
#     layout      "home"


#     interface "eth0" do
#       bootproto :static
#       ip        "99.99.1.#{octet}"
#       network   "org"
#     end
#   end
# end
