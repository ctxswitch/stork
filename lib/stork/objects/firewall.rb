module Stork
  module Objects
    class Firewall
      attr_accessor :enabled
      attr_accessor :trusted_devices
      attr_accessor :ports_allowed
      attr_accessor :ssh
      attr_accessor :telnet
      attr_accessor :smtp
      attr_accessor :http
      attr_accessor :ftp

      def initialize
        @enabled = true
        @trusted_devices = []
        @ports_allowed = []
        @ssh = true
        @telnet = false
        @smtp = false
        @http = false
        @ftp = false
      end

      def self.build(&block)
        fw = new
        delegator = FirewallDelegator.new(fw)
        delegator.instance_eval(&block)
        fw
      end

      class FirewallDelegator
        def initialize(obj)
          @delegated = obj
        end

        def disable
          @delegated.enabled = false
        end

        def trusted(value)
          @delegated.trusted_devices << value
        end

        def allow(value)
          @delegated.ports_allowed << value
        end

        def nossh
          @delegated.ssh = false
        end

        def telnet
          @delegated.telnet = true
        end

        def smtp
          @delegated.smtp = true
        end

        def http
          @delegated.http = true
        end

        def ftp
          @delegated.ftp = true
        end
      end
    end
  end
end
