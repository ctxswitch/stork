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
    class Distro
      include Midwife::Core

      attr_reader :name, :kernel, :initrd, :url
      
      def initialize(name)
        @name = name
        @kernel = "vmlinuz"
        @initrd = "initrd.img"
        @url = "http://localhost"
      end

      def kernel_url
        "#{@url}/#{@kernel}"
      end

      def initrd_url
        "#{@url}/#{@initrd}"
      end

      def set_kernel(name)
        @kernel = name
      end

      def set_initrd(name)
        @initrd = name
      end

      def set_url(path)
        @url = path
      end

      def self.build(name, &block)
        distro = new(name)
        delegator = DistroDelegator.new(distro)
        delegator.instance_eval(&block)
        distro
      end

      class DistroDelegator < SimpleDelegator
        def kernel(name)
          set_kernel(name)
        end

        def initrd(name)
          set_initrd(name)
        end

        def url(path)
          set_url(path)
        end
      end

    end
  end
end