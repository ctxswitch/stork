module Midwife
  module DSL
    class Net
      include Base
      allow_objects :domain
      string :ethtool
      string :ip
      symbol :bootproto
      boolean :onboot
      boolean :noipv4
      boolean :noipv6
      boolean :nodns
      boolean :nodefroute
      integer :mtu
      boolean :primary
      domain :domain
    end
  end
end
