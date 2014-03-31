module Midwife
  module DSL
    class Interface
      attr_reader :device
      attr_accessor :ethtool
      attr_accessor :ip
      attr_accessor :bootproto
      attr_accessor :onboot
      attr_accessor :noipv4
      attr_accessor :noipv6
      attr_accessor :nodns
      attr_accessor :nodefroute
      attr_accessor :mtu
      attr_accessor :netmask
      attr_accessor :gateway
      attr_accessor :nameservers
      attr_accessor :search_paths

      def initialize(device)
        @device = device
        @bootproto = 'dhcp'
        @ip = nil
        @onboot = true
        @noipv4 = false
        @noipv6 = true
        @nodns = false
        @nodefroute = false
        @mtu = nil
        @netmask = nil
        @gateway = nil
        @nameservers = []
        @search_paths = []
      end

      def static?
        @bootproto == "static"
      end

      def self.build(collection, device, &block)
        interface = new(device)
        delegator = InterfaceDelegator.new(collection, interface)
        delegator.instance_eval(&block)
        interface
      end

      class InterfaceDelegator
        def initialize(collection, obj)
          @collection = collection
          @delegated = obj
        end

        def ethtool(value)
          @delegated.ethtool = value
        end

        def bootproto(value)
          @delegated.bootproto = value.to_s
        end

        def ip(value)
          @delegated.ip = value.to_s
        end

        def onboot(value=true)
          @delegated.onboot = value
        end

        def noipv4
          @delegated.noipv4 = true
        end

        def noipv6
          @delegated.noipv6 = true
        end

        def nodns
          @delegated.nodns = true
        end

        def nodefroute
          @delegated.nodefroute = true
        end

        def mtu(value)
          @delegated.mtu = value.to_i
        end

        def netmask(value)
          @delegated.netmask = value
        end

        def gateway(value)
          @delegated.gateway = value
        end

        def nameserver(value)
          @delegated.nameservers << value
        end

        def search_path(value)
          @delegated.search_paths << value
        end

        def network(value)
          net = @collection.networks.get(value)
          unless net
            raise SyntaxError, "Could not find #{value} in networks"
          end

          @delegated.netmask = net.netmask
          @delegated.gateway = net.gateway
          @delegated.nameservers = net.nameservers
          @delegated.search_paths = net.search_paths
        end
      end
    end
  end
end
