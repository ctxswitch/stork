module Stork
  module Resource
    class Timezone < Base
      attribute :utc, type: :boolean
      attribute :ntp, type: :boolean
      attribute :ntpserver, type: :array

      def initialize(zone, options = {})
        @name = zone
        @utc = false
        @ntp = true
        @ntpservers = %w(
          0.pool.ntp.org
          1.pool.ntp.org
          2.pool.ntp.org
          3.pool.ntp.org
)
      end

      alias_method :zone, :name
    end
  end
end
