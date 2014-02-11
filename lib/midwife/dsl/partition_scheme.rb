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
    class PartitionScheme
      attr_reader :name, :clearpart, :zerombr, :partitions
      def initialize(name)
        @name = name
        @clearpart = false
        @zerombr = false
        @partitions = []
      end

      def set_zerombr
        @zerombr = true
      end

      def set_clearpart
        @clearpart = true
      end

      def add_partition(name, &block)
        @partitions << Midwife::DSL::Partition.build(name, &block)
      end

      def emit
        str = ""
        str += "zerombr yes\n" if zerombr
        str += "clearpart --all --initlabel\n" if clearpart
        partitions.each do |part|
          str += part.emit + "\n"
        end
        str
      end

      def self.build(name, &block)
        scheme = PartitionScheme.new(name)
        delegator = SchemeDelegator.new(scheme)
        delegator.instance_eval(&block) if block_given?
        scheme
      end

      class SchemeDelegator < SimpleDelegator
        def zerombr
          set_zerombr
        end

        def clearpart
          set_clearpart
        end

        def part(name, &block)
          add_partition(name, &block)
        end
      end
    end
  end
end
