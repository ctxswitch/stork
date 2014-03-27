module Midwife
  module DSL
    class Partition
      attr_reader :path
      attr_accessor :size
      attr_accessor :type
      attr_accessor :primary
      attr_accessor :grow
      attr_accessor :recommended

      def initialize(path)
        @path = path
        @size = 1
        @type = "ext4"
        @grow = false
        @primary = false
        @recommended = true
      end

      def self.build(path, &block)
        partition = new(path)
        delegator = PartitionDelegator.new(partition)
        delegator.instance_eval(&block)
        partition
      end

      class PartitionDelegator
        def initialize(obj)
          @delegated = obj
        end

        def size(value)
          @delegated.recommended = false
          @delegated.size = value
        end

        def type(value)
          @delegated.type = value
        end

        def primary
          @delegated.primary = true
        end

        def grow
          @delegated.grow = true
        end

        def recommended
          @delegated.recommended = true
        end
      end
    end
  end
end
