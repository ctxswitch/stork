module Midwife
  module DSL
    class Distros
      def initialize
        @distros = {}
      end

      def find(name)
        @distros[name]
      end

      def add_distro(name, &block)
        @distros[name] = Midwife::DSL::Distro.build(name, &block)
      end

      def self.build(&block)
        distros = new
        delegator = DistrosDelegator.new(distros)
        unless block_given?
          Dir.glob("#{Midwife.configuration.path}/distros/*.rb").each do |filename|
            delegator.instance_eval(File.read(filename), filename)
          end
        else
          delegator.instance_eval(&block)
        end
        distros
      end

      class DistrosDelegator < SimpleDelegator
        def distro(name, &block)
          add_distro(name, &block)
        end
      end
    end
  end
end