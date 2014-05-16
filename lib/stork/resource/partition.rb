module Stork
  module Resource
    class Partition < Base
      attr_accessor :size
      attr_accessor :type
      attr_accessor :primary
      attr_accessor :grow
      attr_accessor :recommended

      def setup
        @size = 1
        @type = 'ext4'
        @grow = false
        @primary = false
        @recommended = false
      end

      alias_method :path, :name

      class PartitionDelegator < Stork::Resource::Delegator
        flag :primary
        flag :grow
        flag :recommended

        def size(size)
          delegated.size = size
          delegated.recommended = false
        end

        def type(type)
          delegated.type = type
        end
      end
    end
  end
end
