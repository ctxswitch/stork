module Stork
  module Resource
    class Interface < Base
      attr_accessor :ethtool
      attr_accessor :ip
      attr_accessor :mtu
      attr_accessor :bootproto
      attr_accessor :onboot
      attr_accessor :ipv4
      attr_accessor :ipv6
      attr_accessor :dns
      attr_accessor :defroute
      attr_accessor :network

      def setup
        @network = Network.new
        @bootproto = :dhcp
        @ip = nil
        @mtu = nil
        @onboot = true
        @ipv4 = true
        @ipv6 = false
        @defroute = true
        @ethtool = nil
      end

      def validate!

      end

      def netmask
        network.netmask
      end

      def gateway
        network.gateway
      end

      def nameservers
        network.nameservers
      end

      def search_paths
        network.search_paths
      end

      def noipv4
        !ipv4
      end

      def noipv6
        !ipv6
      end

      def nodns
        !dns
      end

      def nodefroute
        !defroute
      end

      def static?
        @bootproto == :static
      end

      def hashify
        {
          'ip' => ip,
          'bootproto' => bootproto,
          'netmask' => netmask,
          'gateway' => gateway,
          'nameservers' => nameservers,
          'search_paths' => search_paths
        }
      end

      alias_method :device, :name

      class InterfaceDelegator < Stork::Resource::Delegator
        flag :onboot
        flag :ipv4
        flag :ipv6
        flag :dns
        flag :defroute

        def ethtool(ethtool)
          delegated.ethtool = ethtool
        end

        def ip(ip)
          delegated.ip = ip
        end

        def mtu(mtu)
          delegated.mtu = mtu
        end

        def bootproto(bootproto)
          delegated.bootproto = bootproto
        end

        def network(network)
          delegated.network = get_collection_item(:network, network)
        end

        def netmask(netmask)
          delegated.network.netmask = netmask
        end

        def gateway(gateway)
          delegated.network.gateway = gateway
        end

        def nameserver(nameserver)
          delegated.network.nameservers << nameserver
        end

        def search_path(search_path)
          delegated.network.search_paths << search_path
        end
      end
    end
  end
end
