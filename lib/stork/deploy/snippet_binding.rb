module Stork
  module Deploy
    class SnippetBinding
      attr_reader :host

      def initialize(host)
        @host = host
      end

      def get_binding
        binding
      end

      def chef
        host.chef
      end

      def authorized_keys
        File.read(Configuration[:authorized_keys_file])
      end

      def first_boot_content
        run_list = {}
        run_list['run_list'] = host.run_list
        run_list.to_json
      end

      def nameservers
        host.interfaces.map { |x| x.nameservers }.uniq.flatten
      end

      def search_paths
        host.interfaces.map { |x| x.search_paths }.uniq.flatten
      end

      def stork_server
        Configuration[:server]
      end

      def stork_port
        Configuration[:port]
      end

      def stork_bind
        Configuration[:bind]
      end

      # Add aliases for old midwife methods
      alias_method :midwife_server, :stork_server
      alias_method :midwife_port, :stork_port
      alias_method :midwife_bind, :stork_bind
    end
  end
end
