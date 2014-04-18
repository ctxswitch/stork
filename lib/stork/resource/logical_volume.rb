module Stork
  module Resource
    class LogicalVolume < Base
      attribute :path
      attribute :size
      attribute :type
      attribute :primary, type: :boolean
      attribute :grow, type: :boolean
      attribute :recommended, type: :boolean

      def initialize(name, options = {})
        @name = name
        @size = 1
        @type = 'ext4'
        @grow = false
        @recommended = true
        @path = '/'
      end
    end
  end
end
