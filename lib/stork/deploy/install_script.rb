module Stork
  module Deploy
    class InstallScript
      attr_reader :type, :host

      def initialize(host, type=:kickstart)
        @host = host
        @type = type
      end

      def render
        renderer = ERB.new(host.template.content)
        binding = InstallScriptBinding.new(type, host).get_binding
        renderer.result(binding)
      end

      require 'forwardable'
      class InstallScriptBinding
        extend Forwardable
        def_delegators :@builder, :url, :network, :password, :firewall,
          :timezone, :selinux, :layout, :partitions, :repos, :volume_groups,
          :packages, :pre_snippets, :post_snippets
        attr_reader :host

        def initialize(type, host)
          # puts Stork::Deploy::Commands.constants.inspect
          @builder = Stork::Deploy.const_get("#{type.to_s.capitalize}Binding").new(host)
          @host = host
        end

        def get_binding
          binding
        end
      end
    end
  end
end
