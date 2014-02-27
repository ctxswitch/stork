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
    class VolumeGroup
      
      attr_reader :name, :physvol, :logvols
      def initialize(name)
        @name = name
        @physvol = nil
        @logvols = []
      end

      def set_physvol(vol)
        @physvol = vol
      end

      def add_logvol(path)
        @logvols << LogicalVolume.build(path, &block)
      end

      def emit
        str = ""
        str += " --netmask=#{@netmask}" if @netmask
        str += " --gateway=#{@gateway}" if @gateway
        str += " --nameserver=#{@nameservers.join(',')}" unless @nameservers.empty?
        str.strip
      end

      def self.build(name, &block)
        vg = new(name)
        delegator = VolumeDelegator.new(vg)
        delegator.instance_eval(&block) if block_given?
        vg
      end

      class VolumeDelegator < SimpleDelegator
        def physvol(vol)
          set_physvol(vol)
        end

        def logvol(path, &block)
          add_logvol(path, &block)
        end
      end
    end
  end
end