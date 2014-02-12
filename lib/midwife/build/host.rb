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
    class Host
      include Midwife::Core

      attr_reader :distro, :template, :partitions, :interfaces, :name, :pxemac

      def initialize(name)
        @name = name
        @template = nil
        @distro = nil
        @interfaces = []
        @pxemac = nil
      end

      def set_template(content)
        @template = content
      end

      def set_partitions(scheme)
        @partitions = scheme
      end

      def set_distro(distro)
        @distro = distro
      end

      def set_interface(device, &block)
        @interfaces << Midwife::Build::NetworkInterface.build(device, &block)
      end

      def set_pxemac(mac)
        @pxemac = mac
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
          content = builder.templates[tmpl]
          raise Midwife::NotFound.new "Template \"#{tmpl}\" not found" unless content
          set_template(content)
        end

        def scheme(name)
          scheme = Midwife::Build::Scheme.find(name)
          raise Midwife::NotFound.new "Scheme \"#{name}\" not found" unless scheme
          set_partitions(scheme)
        end

        def interface(device, &block)
          set_interface(device, &block)
        end

        def distro(name)
          distro = Midwife::Build::Distro.find(name)
          raise Midwife::NotFound.new "Distro \"#{name}\" not found" unless distro
          set_distro(distro)
        end

        def pxemac(mac)
          set_pxemac(mac)
        end
      end
    end
  end
end
