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
    class Partitions
      def initialize(name)
        @name = name
        @clearpart = false
        @partitions = []
      end

      def zerombr
        @zerombr = true
      end

      def clearpart
        @clearpart = true
      end

      def part(name, &block)
        @partitions << Midwife::DSL::Partition.new(name).tap do |p|
          p.instance_eval(&block)
        end
      end

      def emit
        str = ""
        str += "zerombr yes\n" if @zerombr
        str += "clearpart --all --initlabel\n" if @clearpart
        @partitions.each do |part|
          str += part.emit + "\n"
        end
        str
      end
    end
  end
end
