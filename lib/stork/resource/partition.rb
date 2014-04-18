module Stork
  module Resource
    class Partition < Base
      attr_reader :path
      attribute :size
      attribute :type
      attribute :primary, type: :boolean
      attribute :grow, type: :boolean
      attribute :recommended, type: :boolean

      def initialize(path, options = {})
        @path = path
        @size = 1
        @type = 'ext4'
        @grow = false
        @primary = false
        @recommended = true
      end
    end
  end
end
