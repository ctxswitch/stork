module Midwife
  module Build
    class Distro
      include Midwife::Core

      attr_reader :name, :kernel, :initrd, :url
      
      def initialize(name)
        @name = name
        @kernel = "vmlinuz"
        @initrd = "initrd.img"
        @url = "http://localhost"
      end

      def kernel_url
        "#{@url}/#{@kernel}"
      end

      def initrd_url
        "#{@url}/#{@initrd}"
      end

      def set_kernel(name)
        @kernel = name
      end

      def set_initrd(name)
        @initrd = name
      end

      def set_url(path)
        @url = path
      end

      def self.build(name, &block)
        distro = new(name)
        delegator = DistroDelegator.new(distro)
        delegator.instance_eval(&block)
        distro
      end

      class DistroDelegator < SimpleDelegator
        def kernel(name)
          set_kernel(name)
        end

        def initrd(name)
          set_initrd(name)
        end

        def url(path)
          set_url(path)
        end
      end

    end
  end
end