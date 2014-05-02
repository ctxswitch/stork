module Stork
  module Resource
    class Network < Base
      attr_accessor :netmask
      attr_accessor :gateway
      attr_accessor :nameservers
      attr_accessor :search_paths

      def setup
        @netmask = "255.255.255.0"
        @gateway = "192.168.0.1"
        @nameservers = Array.new
        @search_paths = Array.new
      end

      class NetworkDelegator < Stork::Resource::Delegator
        def netmask(netmask)
          delegated.netmask = netmask
        end

        def gateway(gateway)
          delegated.gateway = gateway
        end

        def nameserver(nameserver)
          delegated.nameservers << nameserver
        end

        def search_path(search_path)
          delegated.search_paths << search_path
        end
      end

    end
  end
end
