host "other1.private" do
  template    'default'
  partitions  'default'
  # pxemac    00:11:22:33:44:56
  interface   "eth0"
end