module Stork
  module Resource
    class Chef < Base
      # attr_reader :name
      attribute :url
      attribute :version
      attribute :client_key, type: :file
      attribute :client_name
      attribute :validator_name
      attribute :validation_key, type: :file
      attribute :encrypted_data_bag_secret

      def client_content
        lines = []
        lines << 'log_level        :auto'
        lines << 'log_location     STDOUT'
        lines << "chef_server_url  \"#{url}\""
        lines << "validation_client_name \"#{validator_name}\""
        lines << '# Using default node name (fqdn)'
        lines.join("\n")
      end

      def knife_content
        lines = []
        'log_level                :info'
        'log_location             STDOUT'
        "node_name                \"#{client_name}\""
        "client_key               \"/root/.chef/#{client_name}.pem\""
        "validation_client_name   \"#{validator_name}\""
        "validation_key           \"/etc/chef/validation.pem\""
        "chef_server_url          \"#{url}\""
        "cache_type               \"BasicFile\""
        "cache_options( :path => \"/root/.chef/checksums\" )"
        lines.join("\n")
      end
    end
  end
end
