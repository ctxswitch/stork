module Midwife
  class Hosts
    def initialize
      @hosts = []
      Midwife.set_hosts(self)
    end

    def hosts
      @hosts = Hosts
    end

    def add_host(name, &block)
      @hosts[name] = Midwife::DSL::Host.build(name, &block)
    end

    def self.build(path)
      Dir.glob("#{path}/hosts/*.rb").each do |filename|
        name = File.basename(filename, '.rb')
        delegator.instance_eval(File.read(filename), filename)
      end
      config
    end

    class ConfigDelegator < SimpleDelegator
      def host(name, &block)
        add_host(name, &block)
      end
    end
  end
end