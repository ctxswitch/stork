module Stork
  module Resource
    class Timezone < Base
      attr_accessor :utc
      attr_accessor :ntp
      attr_accessor :ntpservers

      def setup
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

      class TimezoneDelegator < Stork::Resource::Delegator
        flag :utc
        flag :ntp

        def ntpserver(ntpserver)
          delegated.ntpservers << ntpserver
        end
      end
    end
  end
end
