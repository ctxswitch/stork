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
  module DSL
    class NetworkInterface
      def initialize(device)
        @device = device
        @ip = nil
        @domain = nil
        @bootproto = :dhcp
        @onboot = true
        @noipv4 = false
        @noipv6 = false
        @nodns = false
        @nodef = false
        @mtu = nil
        @ethtool = nil
      end

      def ip(val)
        @ip = val
      end

      def domain(val)
        @domain = val
      end

      def bootproto(val)
        raise InvalidArgument("must be :static or :dhcp") unless [:static, :dhcp, :bootp].include?(val)
        @bootproto = val
      end

      def noboot
        @onboot = false
      end

      def noipv4
        @noipv4 = true
      end

      def noipv6
        @noipv6 = true
      end

      def nodefroute
        @nodefroute = true
      end

      def nodns
        @nodns = true
      end

      def ethtool(val)
        @ethtool = val
      end

      def mtu(val)
        @mtu = val
      end

      def emit
        str = "network --device=#{@device} --bootproto=#{@bootproto.to_s}"
        # Handle the static setup
        if @bootproto == :static
          str += " --ip=#{@ip}"
          str += " #{@domain.emit}" if @domain
        end
        # Others
        str += " --onboot=#{@onboot ? 'yes' : 'no'}"
        str += " --noipv4" if @noipv4
        str += " --noipv6" if @noipv6
        str += " --nodefroute" if @nodefroute
        str += " --nodns" if @nodns
        str += " --ethtool=\"#{@ethtool}\"" if @ethtool
        str += " --mtu=#{@mtu}" if @mtu
        str
      end
    end
  end
end