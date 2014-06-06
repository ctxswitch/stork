module Stork
  module Resource
    class Layout < Base
      attr_accessor :zerombr
      attr_accessor :clearpart
      attr_accessor :partitions
      attr_accessor :volume_groups
      # attr_accessor :raid_groups

      def setup
        @zerombr = false
        @clearpart = false
        @partitions = Array.new
        @volume_groups = Array.new
      end

      def validate!
        if partitions.empty?
          fail SyntaxError, 'You must supply a partition block'
        end
      end

      def hashify
        {
          'partitions' => partitions.map{|p| p.hashify},
          'volume_groups' => volume_groups.map{|v| v.hashify}
        }
      end

      class LayoutDelegator < Stork::Resource::Delegator
        flag :zerombr
        flag :clearpart

        def partition(name, options = {}, &block)
          fail SyntaxError, 'You must supply a block to partition' unless block_given?
          @delegated.partitions << Partition.build(name, options, &block)
        end

        alias_method :part, :partition

        def volume_group(name, options = {}, &block)
          fail SyntaxError, 'You must supply a block to volume_group' unless block_given?
          @delegated.volume_groups << VolumeGroup.build(name, options, &block)
        end

        alias_method :volgroup, :volume_group
      end
    end
  end
end
