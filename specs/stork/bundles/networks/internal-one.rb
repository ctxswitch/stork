network "internal-one" do
  netmask "255.255.255.0"
  gateway "192.168.0.1"
  nameserver "192.168.0.2"
  nameserver "192.168.0.3"
  search_path "example.org"
end
