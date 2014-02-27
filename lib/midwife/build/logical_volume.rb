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
    class LogicalVolume
      
      attr_reader :name, :size, :mntpoint
      def initialize(mntpoint)
        @mntpoint = mntpoint
        @name = "lv"
        @size = 0
      end

      def set_name(name)
        @name = name
      end

      def set_size(size)
        @size = size
      end

      def emit(vgname)
        str = "logvol #{mntpoint} --vgname=#{vgname} --size=#{size} --name=#{name}"
        str.strip
      end

      def self.build(name, &block)
        lv = new(name)
        delegator = LogicalVolumeDelegator.new(lv)
        delegator.instance_eval(&block) if block_given?
        lv
      end

      class LogicalVolumeDelegator < SimpleDelegator
        def name(name)
          set_name(name)
        end

        def size(size)
          set_size(size)
        end
      end
    end
  end
end