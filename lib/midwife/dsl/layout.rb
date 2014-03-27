module Midwife
  module DSL
    class Layout
      attr_reader   :name
      attr_accessor :zerombr
      attr_accessor :clearpart
      attr_accessor :partitions
      attr_accessor :volume_groups
      attr_accessor :raid_groups

      def initialize(name)
        @name = name
        @zerombr = false
        @clearpart = false
        @partitions = []
        @volume_groups = []
      end

      def validate!
        if partitions.empty?
          raise SyntaxError, "You must supply a partition block"
        end
      end

      def self.build(name, &block)
        layout = new(name)
        delegator = LayoutDelegator.new(layout)
        delegator.instance_eval(&block)
        layout.validate!
        layout
      end

      class LayoutDelegator
        def initialize(obj)
          @delegated = obj
        end

        def zerombr
          @delegated.zerombr = true
        end

        def clearpart
          @delegated.clearpart = true
        end

        def partition(value, &block)
          unless block_given?
            raise "Need a block dude!"
          end
          @delegated.partitions << Partition.build(value, &block)
        end

        def volume_group(value, options={}, &block)
          unless block_given?
            raise "Need a block dude!"
          end
          @delegated.volume_groups << VolumeGroup.build(value, options, &block)
        end

        alias_method :part, :partition
        alias_method :volgroup, :volume_group
      end

      alias_method :id, :name
    end
  end
end
