module Midwife
  module DSL
    class Timezone
      attr_reader :zone
      attr_accessor :utc
      attr_accessor :nontp
      attr_accessor :ntpservers

      def initialize(zone)
        @zone = zone
        @utc = true
        @nontp = false
        @ntpservers = %w{
          0.pool.ntp.org
          1.pool.ntp.org
          2.pool.ntp.org
          3.pool.ntp.org
        }
      end
    end
  end
end
