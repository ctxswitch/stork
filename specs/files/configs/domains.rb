domain "private" do
  netmask "255.255.255.0"
end

domain "test" do
  netmask "255.255.255.192"
end

domain "local" do
  netmask "255.255.255.0"
  gateway "192.168.1.1"
  nameserver "192.168.1.1"
  nameserver "192.168.1.2"
end