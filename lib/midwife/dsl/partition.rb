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
    class Partition
      def initialize(path)
        @path = path
        @size = 0
        @type = "ext4"
        @primary = false
        @grow = false
      end

      def size(val)
        @size = val
      end

      def type(val)
        @type = val
      end

      def primary
        @primary = true
      end

      def grow
        @grow = true
      end

      def emit
        str = "part #{@path}"
        str += (@size > 0 ? " --size #{@size}" : " --recommended")
        str += " --fstype #{@type}"
        str += " --grow" if @grow
        str += " --asprimary" if @primary
        str
      end
    end
  end
end