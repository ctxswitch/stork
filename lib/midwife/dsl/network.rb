module Midwife
  module DSL
    class Network
      attr_reader :name
      attr_accessor :netmask
      attr_accessor :gateway
      attr_accessor :nameservers

      def initialize(name)
        @name = name
        @netmask = nil
        @gateway = nil
        @nameservers = []
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
      end

      alias_method :id, :name
    end
  end
end
