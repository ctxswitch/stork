module Stork
  module Deploy
    module Commands
      class Snippet
        attr_reader :host

        def initialize(configuration, host)
          @host = host
          @configuration = configuration
        end

        def get_binding
          binding
        end

        def chef
          host.chef
        end

        def authorized_keys
          File.read(@configuration.authorized_keys_file)
        end

        def first_boot_content
          run_list = { 'run_list' => host.run_list }
          run_list.to_json
        end

        def nameservers
          host.interfaces.map { |x| x.nameservers }.uniq.flatten
        end

        def search_paths
          host.interfaces.map { |x| x.search_paths }.uniq.flatten
        end

        def midwife_server
          @configuration.server
        end

        def midwife_port
          @configuration.port
        end

        def midwife_bind
          @configuration.bind
        end
      end
    end
  end
end
