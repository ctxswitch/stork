host "other1.private" do
  template    'default'
  scheme      'default'
  distro      'centos'
  chef        'default'
  pxemac      '00:11:22:33:44:56'
  interface   "eth0"
  run_list    %w{
    recipe[sudo]
    recipe[authentication]
    recipe[nagios]
    recipe[apache]
  }
end

host "static1.private" do
  template  'default'
  scheme    'default'
  distro    'centos'
  chef      'default'
  interface 'eth0' do
    domain    'local'
    bootproto :static
    ip        '192.168.1.100'
  end
end

host "default1.local" do
  scheme    'default'
  distro    'centos'
  chef      'default'
  interface 'eth0' do
    domain    'local'
    bootproto :static
    ip        '192.168.1.100'
  end
end