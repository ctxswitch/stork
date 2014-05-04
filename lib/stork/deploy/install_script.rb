module Stork
  module Deploy
    class InstallScript
      attr_reader :type, :host, :configuration

      def initialize(host, type=:kickstart)
        @host = host
        @type = type
        @configuration = host.configuration
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
        attr_reader :host, :configuration

        def initialize(type, host)
          @builder = Stork::Deploy.const_get("Commands::#{type.to_s.capitalize}").new(host)
          @configuration = configuration
          @host = host.configuration
        end

        def get_binding
          binding
        end
      end
    end
  end
end
