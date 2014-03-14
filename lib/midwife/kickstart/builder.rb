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
  module Kickstart
    class Builder
      attr_reader :template, :host, :domain, :scheme, :chef, :post, :midwife

      def initialize(host, template="default")
        @template = template
        # Should pick up defaults from configurations
        @host = host
        @domain = host.domain
        @scheme = host.scheme
        @chef = host.chef
        @post = nil
        @midwife = host.midwife
      end

      def render
        file = File.dirname(__FILE__) + "/templates/#{template}.ks.erb"
        renderer = ERB.new(File.read(file))
        renderer.result(BuilderBindings.new(self).get_binding)
      end

      class BuilderBindings
        attr_reader :host, :domain, :scheme, :chef, :post, :midwife
        def initialize(obj)
          @host = obj.host
          @domain = obj.domain
          @scheme = obj.scheme
          @chef = obj.chef
          @post = obj.post
          @midwife = obj.midwife
        end

        def render_snippet(name)
          template = File.dirname(__FILE__) + "/snippets/#{name}.erb"
          renderer = ERB.new(File.read(template))
          renderer.result(get_binding)
        end

        def get_binding
          binding
        end

        def partitions
          scheme.partitions || []
        end

        def network
          host.network || []
        end

        def hostname
          host.name || localhost
        end

        def dns_nameservers
          domain.nameservers || []
        end

        def dns_search_paths
          domain.search_paths || []
        end

        def ntpserver
          domain.ntpserver
        end

        def authorized_keys
          host.authorized_keys
        end

        def chef_first_boot_content
          chef.first_boot_content
        end

        def chef_client_key
          chef.client_key
        end

        def chef_client_name
          chef.client_name
        end

        def chef_knife_content
          chef.knife_content
        end

        def chef_client_content
          chef.client_content
        end

        def chef_validation_key
          chef.validation_key
        end

        def chef_encrypted_data_bag_secret
          chef.encrypted_data_bag_secret
        end

        def chef_version
          chef.version
        end

        def url
          midwife.url
        end

        def server
          midwife.server
        end

        def password
          host.password
        end

        def firewall
          host.firewall
        end

        def timezone
          host.timezone
        end

        def selinux
          host.selinux
        end

        def packages
          strs = %w{
            @core
            curl
            openssh-clients
            openssh-server
            finger
            pciutils
            yum
            at
            acpid
            vixie-cron
            cronie-noanacron
            crontabs
            logrotate
            ntp
            ntpdate
            tmpwatch
            rsync
            mailx
            which
            wget
            man
          }
          strs.join("\n")
        end
      end
    end
  end
end

