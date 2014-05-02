module Stork
  module Resource
    class VolumeGroup < Base
      attr_reader :name
      attr_accessor :partition
      attr_accessor :logical_volumes

      def setup
        @partition = options.key?(:part) ? options[:part] : nil
        @logical_volumes = Array.new
      end

      class VolumeGroupDelegator < Stork::Resource::Delegator
        def partition(partition)

        end

        def logical_volume(name, options = {}, &block)
          @delegated.logical_volumes << LogicalVolume.build(name, options, &block)
        end
      end
    end
  end
end
