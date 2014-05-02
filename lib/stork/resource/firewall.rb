module Stork
  module Resource
    class Firewall < Base
      attr_accessor :enabled
      attr_accessor :ssh
      attr_accessor :telnet
      attr_accessor :smtp
      attr_accessor :http
      attr_accessor :ftp
      attr_accessor :trusted_devices
      attr_accessor :allowed_ports
      
      def setup
        @enabled = true
        @ssh = true
        @telnet = false
        @smtp = false
        @http = false
        @ftp = false
        @trusted_devices = Array.new
        @allowed_ports = Array.new
      end

      class FirewallDelegator < Stork::Resource::Delegator
        flag :enabled, negate: :disable
        flag :ssh
        flag :telnet
        flag :smtp
        flag :http
        flag :ftp

        def trusted_device(device)
          delegated.trusted_devices << device
        end

        alias_method :trusted, :trusted_device
        alias_method :trust, :trusted_device

        def allowed_port(port)
          delegated.allowed_ports << port
        end

        alias_method :allow, :allowed_port
      end
    end
  end
end
