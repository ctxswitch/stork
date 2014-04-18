module Stork
  module Resource
    class Layout < Base
      attribute :zerombr, type: :boolean, default: false
      attribute :clearpart, type: :boolean, default: false
      attribute :partition, type: :array, 
                            of: :resources, 
                            resource: :partition, 
                            as: :part, 
                            required: true
      attribute :volume_group,  type: :array, 
                                of: :resources, 
                                resource: :volume_group, as: :volgroup
      # attributes :raid_groups

      def initialize(name, options = {})
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
    end
  end
end
