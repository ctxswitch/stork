module Stork
  module Objects
    class Distro
      attr_reader :name
      attr_accessor :kernel
      attr_accessor :image
      attr_accessor :url

      def initialize(name)
        @name = name
        @kernel = nil
        @image = nil
        @url = nil
      end

      def self.build(name, &block)
        distro = new(name)
        delegator = DistroDelegator.new(distro)
        delegator.instance_eval(&block)
        distro
      end

      class DistroDelegator
        def initialize(obj)
          @delegated = obj
        end

        def kernel(value)
          @delegated.kernel = value
        end

        def image(value)
          @delegated.image = value
        end

        def url(value)
          @delegated.url = value
        end
      end

      alias_method :id, :name
    end
  end
end