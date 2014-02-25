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

require 'securerandom'
require "json"

module Midwife
  module Build
    class Host
      include Midwife::Core

      attr_reader :distro, :template, :partitions, :interfaces, :name, :pxemac
      attr_reader :run_list, :timezone, :selinux, :run_list, :password, :chef

      def initialize(name)
        @name = name
        @template = nil
        @distro = nil
        @interfaces = []
        @pxemac = nil
        @chef = nil
        @timezone = "America/Los_Angeles"
        @selinux = 'disabled'
        @password = random_password
        @run_list = []
        @search_paths = []
      end

      def random_password
        salt = rand(36**8).to_s(36)
        randstring = SecureRandom.urlsafe_base64(40)
        @password ||= randstring.crypt("$6$" + salt)
      end

      def bootstrap
        chef.emit(name, run_list) if chef
      end

      def resolv_conf
        str = ""
        nameservers = primary_interfaces.collect{ |x| x.domain.nameservers }.flatten

        unless nameservers.empty?
          str += "cat > /etc/resolv.conf << 'EOF'\n"
          nameservers.each do |nameserver|
            str += "nameserver #{nameserver}\n"
          end
          str += "search #{@search_paths.join{' '}}\n" unless @search_paths.empty?
          str += "EOF\n"
        end
        str
      end

      def primary_interfaces
        @primary_interfaces ||= @interfaces.keep_if{ |x| x.is_primary? }
      end

      def pxe
        @pxe ||= Midwife::PXE.new(self)
      end

      def set_localboot
        pxe.localboot
      end

      def set_install
        pxe.install
      end

      def set_run_list(arr)
        @run_list |= arr
      end

      def set_selinux(val)
        @selinux = val
      end

      def set_timezone(zone)
        @timezone = zone
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

      def set_chef(chef)
        @chef = chef
      end

      def set_interface(device, &block)
        @interfaces << Midwife::Build::NetworkInterface.build(device, &block)
      end

      def set_pxemac(mac)
        @pxemac = mac
      end

      def add_search_path(path)
        @search_paths << path
      end

      def emit
        # Allow user to override the default template
        unless @template
          template = File.dirname(__FILE__) + '/../erbs/kickstart.erb'
          renderer = ERB.new(File.read(template))
          renderer.result(binding())
        else
          renderer = ERB.new(@template)
          renderer.result(binding())
        end
      end

      def self.build(name, &block)
        host = new(name)
        delegator = HostDelegator.new(host)
        delegator.instance_eval(&block) if block_given?
        host
      end

      class HostDelegator < SimpleDelegator
        def selinux(val)
          raise InvalidArgument("must be :enforcing, :disabled, or :permissive") unless [:enforcing, :disabled, :permissive].include?(val)
          set_selinux val.to_s
        end

        def timezone(zone)
          set_timezone(zone)
        end

        def run_list(list)
          set_run_list(list.is_a?(String)?list.split(',') : list)
        end

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

        def chef(name)
          chef = Midwife::Build::Chef.find(name)
          raise Midwife::NotFound.new "Chef \"#{name}\" not found" unless chef
          set_chef(chef)
        end

        def pxemac(mac)
          set_pxemac(mac)
        end

        def search_path(path)
          add_search_path(path)
        end
      end
    end
  end
end
