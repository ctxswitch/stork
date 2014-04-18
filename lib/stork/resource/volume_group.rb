module Stork
  module Resource
    class VolumeGroup < Base
      attr_reader :name
      attr_accessor :partition
      attribute :logical_volume, type: :array, of: :resources, resource: :logical_volume

      def initialize(name, options = {})
        @name = name
        @partition = options.key?(:part) ? options[:part] : nil
        @logical_volumes = []
      end
    end
  end
end
