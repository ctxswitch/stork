# Config for example.org
host "server.example.org" do
  template    "default"
  chef        "default"
  pxemac      "00:11:22:33:44:55"
  layout      "home"
  distro      "centos"
  repo        "whamcloud-client", baseurl: "http://yum.example.com/eln/x86_64"
  package     "foo"


  interface "eth0" do
    bootproto :static
    ip        "99.99.1.8"
    # network   "org"
  end

  interface "eth1" do
    bootproto :static
    ip        "192.168.1.10"
    netmask   "255.255.255.0"
    gateway   "192.168.1.1"
    nameserver "192.168.1.253"
    nameserver "192.168.1.252"
  end

  pre_snippet    "setup"
  post_snippet   "ntp"
  post_snippet   "resolv-conf"
  post_snippet   "chef-bootstrap"
  post_snippet   "chef-reconfigure"
  post_snippet   "notify"

  run_list %w{ role[base] recipe[apache] }
end

hosts=[
  [10, "00:11:22:33:44:01"],
  [11, "00:11:22:33:44:02"],
  [12, "00:11:22:33:44:03"],
  [13, "00:11:22:33:44:04"],
  [14, "00:11:22:33:44:05"],
  [15, "00:11:22:33:44:06"],
  [16, "00:11:22:33:44:07"],
  [17, "00:11:22:33:44:08"],
  [18, "00:11:22:33:44:09"],
  [19, "00:11:22:33:44:10"]
]

hosts.each do |octet, mac|
  host "c0#{octet}.example.org" do
    template    "default"
    chef        "default"
    distro      "centos"
    pxemac      mac
    layout      "home"


    interface "eth0" do
      bootproto :static
      ip        "192.168.10.#{octet}"
      network   "org"
    end
    run_list %w{ role[node] }
  end
end