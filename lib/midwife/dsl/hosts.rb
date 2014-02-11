module Midwife
  module DSL
    class Hosts
      def initialize
        @hosts = {}
      end

      def find(name)
        @hosts[name]
      end

      def size
        @hosts.keys.size
      end

      def add_host(name, &block)
        @hosts[name] = Host.build(name, &block)
      end

      def self.build(&block)
        hosts = new
        delegator = HostsDelegator.new(hosts)
        unless block_given?
          Dir.glob("#{Midwife.configuration.path}/hosts/*.rb").each do |filename|
            delegator.instance_eval(File.read(filename), filename)
          end
        else
          delegator.instance_eval(&block)
        end
        hosts
      end

      class HostsDelegator < SimpleDelegator
        def host(name, &block)
          add_host(name, &block)
        end
      end

    end
  end
end