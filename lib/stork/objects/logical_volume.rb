module Stork
  module Objects
    class LogicalVolume
      attr_reader :name
      attr_accessor :path
      attr_accessor :size
      attr_accessor :type
      attr_accessor :grow
      attr_accessor :recommended

      def initialize(name)
        @name = name
        @size = 1
        @type = "ext4"
        @grow = false
        @recommended = true
        @path = "/"
      end

      def self.build(name, &block)
        lv = new(name)
        delegator = LogicalVolumeDelegator.new(lv)
        delegator.instance_eval(&block)
        lv
      end

      class LogicalVolumeDelegator
        def initialize(obj)
          @delegated = obj
        end

        def path(value)
          @delegated.path = value
        end

        def size(value)
          @delegated.recommended = false
          @delegated.size = value
        end

        def type(value)
          @delegated.type = value
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
