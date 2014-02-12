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
    class Partition
      attr_reader :path, :size, :type, :primary, :grow

      def initialize(path)
        @path = path
        @size = 0
        @type = "ext4"
        @primary = false
        @grow = false
      end

      def set_size(val)
        @size = val
      end

      def set_type(val)
        @type = val
      end

      def set_primary
        @primary = true
      end

      def set_grow
        @grow = true
      end

      def emit
        str = "part #{path}"
        str += (size > 0 ? " --size #{size}" : " --recommended")
        str += " --fstype #{type}"
        str += " --grow" if grow
        str += " --asprimary" if primary
        str
      end

      def self.build(name, &block)
        partition = Partition.new(name)
        delegator = PartitionDelegator.new(partition)
        delegator.instance_eval(&block) if block_given?
        partition
      end

      class PartitionDelegator < SimpleDelegator
        def size(val)
          set_size(val)
        end

        def type(val)
          set_type(val)
        end

        def primary
          set_primary
        end

        def grow
          set_grow
        end
      end
    end
  end
end