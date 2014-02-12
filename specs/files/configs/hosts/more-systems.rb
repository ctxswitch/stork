host "other1.private" do
  template    'default'
  scheme      'default'
  # pxemac    00:11:22:33:44:56
  interface   "eth0"
end

host "static1.private" do
  template  'default'
  scheme    'default'
  interface 'eth0' do
    domain    'local'
    bootproto :static
    ip        '192.168.1.100'
  end
end

host "default1.local" do
  scheme    'default'
  interface 'eth0' do
    domain    'local'
    bootproto :static
    ip        '192.168.1.100'
  end
end