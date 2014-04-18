module Stork
  module Resource
    class Interface < Base
      attribute :ethtool
      attribute :ip
      attribute :mtu
      attribute :bootproto, type: :symbol,
                            default: :dhcp
      attribute :onboot,    type: :boolean, 
                            default: true
      attribute :ipv4,      type: :boolean, 
                            default: true
      attribute :ipv6,      type: :boolean, 
                            default: false
      attribute :dns,       type: :boolean, 
                            default: true
      attribute :defroute,  type: :boolean, 
                            default: true
      attribute :network,   type: :collection, 
                            resource: :network, 
                            forward: [:netmask, :gateway, :nameservers, :search_paths]

      def static?
        @bootproto == "static"
      end

      alias_method :device, :name
    end
  end
end
