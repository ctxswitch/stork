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
    class Host
      attr_reader :template, :partitions, :interfaces, :name

      def initialize(name)
        @name = name
        @template = nil
        @partitions = nil
        @interfaces = []
      end

      def set_template(content)
        @template = content
      end

      def set_partitions(part)
        @partitions = part
      end

      def set_interface(device, &block)
        @interfaces << Midwife::DSL::NetworkInterface.new(device).tap do |i|
          i.instance_eval(&block) if block_given?
        end
      end

      def emit
        if @template
          renderer = ERB.new(@template)
          renderer.result(binding())
        else
          ""
        end
      end

      def self.build(name, &block)
        host = new(name)
        delegator = HostDelegator.new(host)
        delegator.instance_eval(&block) if block_given?
        host
      end

      class HostDelegator < SimpleDelegator
        def template(tmpl)
          content = Midwife.templates[tmpl]
          set_template(content)
        end

        def partitions(part)
          part = Midwife.partitions[part]
          set_partitions(part)
        end

        def interface(device, &block)
          set_interface(device, &block)
        end
      end
    end
  end
end
