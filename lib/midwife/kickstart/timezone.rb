module Midwife
  module Kickstart
    class Timezone < Command
      name 'timezone'
      option 'utc', boolean:true, default: false
      option 'nontp', boolean: true, default: false
      option 'ntpservers', type: Array, default: []

      def emit
        str = name
        str += " --utc" if utc
        str += " --nontp" if nontp
        str += " --ntpservers=#{ntpservers.join(',')}" unless ntpservers.empty?
        str += " #{value}" if value
        str
      end
    end
  end
end