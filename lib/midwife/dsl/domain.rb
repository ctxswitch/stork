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
    class Domain
      attr_reader :name, :netmask, :gateway, :nameservers
      def initialize(name)
        @name = name
        @netmask = nil
        @gateway = nil
        @nameservers = []
      end

      def add_netmask(arg)
        @netmask = arg
      end

      def add_gateway(arg)
        @gateway = arg
      end

      def add_nameserver(server)
        @nameservers << server
      end

      def emit
        str = ""
        str += " --netmask=#{@netmask}" if @netmask
        str += " --gateway=#{@gateway}" if @gateway
        str += " --nameserver=#{@nameservers.join(',')}" unless @nameservers.empty?
        str.strip
      end

      def self.build(name, &block)
        domain = Domain.new(name)
        delegator = DomainDelegator.new(domain)
        delegator.instance_eval(&block) if block_given?
        domain
      end

      class DomainDelegator < SimpleDelegator
        def netmask(arg)
          add_netmask(arg)
        end

        def gateway(arg)
          add_gateway(arg)
        end

        def nameserver(server)
          add_nameserver(server)
        end
      end
    end
  end
end