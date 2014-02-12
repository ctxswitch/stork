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
  module Build
    class NetworkInterface
      include Midwife::Core

      attr_reader :device, :ip, :domain, :bootproto, :onboot, :noipv4
      attr_reader :noipv6, :nodns, :nodefroute, :mtu, :ethtool

      def initialize(device)
        @device = device
        @ip = nil
        @domain = nil
        @bootproto = :dhcp
        @onboot = true
        @noipv4 = false
        @noipv6 = false
        @nodns = false
        @nodefroute = false
        @mtu = nil
        @ethtool = nil
      end

      def set_ip(val)
        @ip = val
      end

      def set_domain(val)
        d = Midwife::Build::Domain.find(val)
        # raise NotFound.new("Unable to find domain \"#{val.name}\"") unless d
        @domain = d
      end

      def set_bootproto(val)
        raise InvalidArgument("must be :static or :dhcp") unless [:static, :dhcp, :bootp].include?(val)
        @bootproto = val
      end

      def set_noboot
        @onboot = false
      end

      def set_noipv4
        @noipv4 = true
      end

      def set_noipv6
        @noipv6 = true
      end

      def set_nodefroute
        @nodefroute = true
      end

      def set_nodns
        @nodns = true
      end

      def set_ethtool(val)
        @ethtool = val
      end

      def set_mtu(val)
        @mtu = val
      end

      def emit
        str = "network --device=#{device} --bootproto=#{bootproto.to_s}"
        # Handle the static setup
        if bootproto == :static
          str += " --ip=#{ip}"
          str += " #{domain.emit}" if domain
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

      def self.build(device, &block)
        iface = new(device)
        delegator = IfaceDelegator.new(iface)
        delegator.instance_eval(&block) if block_given?
        iface
      end

      class IfaceDelegator < SimpleDelegator
        def ip(val)
          set_ip(val)
        end

        def domain(val)
          set_domain(val)
        end

        def bootproto(val)
          set_bootproto(val)
        end

        def noboot
          set_noboot
        end

        def noipv4
          set_noipv4
        end

        def noipv6
          set_noipv6
        end

        def nodefroute
          set_nodefroute
        end

        def nodns
          set_nodns
        end

        def ethtool(val)
          set_ethtool(val)
        end

        def mtu(val)
          set_mtu(val)
        end
      end
    end
  end
end