# Copyright 2012, Rob Lyon
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module Midwife
  module Kickstart
    class NetworkInterface < Command
      # include Midwife::Core
      name 'network'
      option 'ethtool'
      option 'ip'
      option 'bootproto',   type: Symbol, default: :dhcp
      option 'onboot',      boolean: true, default: true
      option 'noipv4',      boolean: true, default: false
      option 'noipv6',      boolean: true, default: false
      option 'nodns',       boolean: true, default: false
      option 'nodefroute',  boolean: true, default: false
      option 'mtu',         type: Integer
      option 'primary',     boolean: true, default: false
      option 'netmask'
      option 'gateway'
      option 'nameservers', type: Array, default: ['bastard']

      def emit
        str = "network --device=#{value} --bootproto=#{bootproto.to_s}"
        # Handle the static setup
        if bootproto == :static
          str += " --ip=#{ip}"
          str += " --netmask=#{netmask}" if netmask
          str += " --gateway=#{gateway}" if gateway
          str += " --nameserver=#{nameservers.join(',')}" unless nameservers.empty?
        end
        # Others
        str += " --onboot=#{onboot ? 'yes' : 'no'}"
        str += " --noipv4" if noipv4
        str += " --noipv6" if noipv6
        str += " --nodefroute" if nodefroute
        str += " --nodns" if nodns
        str += " --ethtool=\"#{ethtool}\"" if ethtool
        str += " --mtu=#{mtu}" if mtu
        str
      end
    end
  end
end