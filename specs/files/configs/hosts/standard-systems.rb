(1..10).to_a.each do |num|
  host "system#{num}.local" do
    template    'default'
    chef        'default'
    scheme      'default'
    # pxemac     00:11:22:33:44:55
    interface   'eth0' do
      domain    'local'
      bootproto :static
      ip        "192.168.1.#{10+num}"
    end
  end
end