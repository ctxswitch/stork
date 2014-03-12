module Midwife
  module Kickstart
    class Firewall < Command
      name 'firewall'
      option 'enabled', boolean: true, default: true, unsets: 'disabled'
      option 'disabled', boolean: true, default: false, unsets: 'enabled'
      option 'ssh', boolean: true, default: true
      option 'smtp', boolean: true, default: false
      option 'http', boolean: true, default: false
      option 'ftp', boolean: true, default: false

      def emit
        str = "firewall"
        if enabled
          str += " --enabled"
          str += " --ssh" if ssh
          str += " --smtp" if smtp
          str += " --http" if http
          str += " --ftp" if ftp
        else
          str += " --disabled"
        end
        str += " #{value}" unless value.empty?
        str
      end
    end
  end
end