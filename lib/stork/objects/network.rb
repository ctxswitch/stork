module Stork
  module Objects
    class Network
      attr_reader :name
      attr_accessor :netmask
      attr_accessor :gateway
      attr_accessor :nameservers
      attr_accessor :search_paths

      def initialize(name)
        @name = name
        @netmask = nil
        @gateway = nil
        @nameservers = []
        @search_paths = []
      end

      def self.build(name, &block)
        network = new(name)
        delegator = NetworkDelegator.new(network)
        delegator.instance_eval(&block)
        network
      end

      class NetworkDelegator
        def initialize(obj)
          @delegated = obj
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
      end

      alias_method :id, :name
    end
  end
end
