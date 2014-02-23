# deploy.rb

###############################################################################
# Domains
###############################################################################
# The private domain
domain "private" do
  netmask "255.255.255.0"
end

# The test domain
domain "test" do
  netmask "255.255.255.192"
end

# The local domain
domain "local" do
  netmask "255.255.255.0"
  gateway "192.168.1.1"
  nameserver "192.168.1.1"
  nameserver "192.168.1.2"
end

###############################################################################
# Partition Schemes
###############################################################################
# The all in one scheme
scheme "default" do
  clearpart
  zerombr
  part "/boot" do
    size 100
    type "ext4"
    primary
  end

  part "swap" do
    size 0 # zero defaults to recommended
    type "swap"
    primary
  end

  part "/" do
    size 1
    type "ext4"
    grow
  end
end

# Split out home
scheme "split" do
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

  part "/home" do
    size 1
    type "ext4"
    grow
  end
end

###############################################################################
# Distros
###############################################################################
distro "redhat" do
  kernel "myredkernel"
  initrd "myredinitrd.img"
  url "http://example.com/redhat"
end

distro "centos" do
  kernel "mycentkernel"
  initrd "mycentinitrd.img"
  url "http://example.com/centos"
end

###############################################################################
# Chefs
###############################################################################
chef "default" do
  url "https://chef.example.org"
  version "11.6.0"
  client_name "root"
  client_key "specs/files/snakeoil-root.pem"
  validator_name "chef-validator"
  validation_key "specs/files/snakeoil-validation.pem"
  encrypted_data_bag_secret "secretkey"
end