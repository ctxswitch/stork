module Stork
  module Objects
    class VolumeGroup
      attr_reader :name
      attr_accessor :partition
      attr_accessor :logical_volumes

      def initialize(name, options = {})
        @name = name
        @partition = options.has_key?(:part) ? options[:part] : nil
        @logical_volumes = []
      end

      def self.build(name, options = {}, &block)
        vg = new(name, options)
        delegator = VolumeGroupDelegator.new(vg)
        delegator.instance_eval(&block) if block_given?
        vg
      end

      class VolumeGroupDelegator
        def initialize(obj)
          @delegated = obj
        end

        def logical_volume(name, &block)
          @delegated.logical_volumes << LogicalVolume.build(name, &block)
        end

        alias_method :logvol, :logical_volume
      end
    end
  end
end
