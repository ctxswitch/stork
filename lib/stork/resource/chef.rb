module Stork
  module Resource
    class Chef < Base
      attr_accessor :url
      attr_accessor :version
      attr_accessor :client_name
      attr_accessor :validator_name
      attr_accessor :client_key
      attr_accessor :validation_key
      attr_accessor :encrypted_data_bag_secret

      def setup
        @url = nil
        @version = nil
        @client_name = "root"
        @validator_name = "chef-validator"
        @validation_key = nil
        @client_key = nil
        @encrypted_data_bag_secret = nil
      end

      def validate!
        # I should make sure that I'm at least getting the url,
        # version, and the files.
        require_value(:url)
        require_value(:version)
        require_value(:validation_key)
        require_value(:client_key)
      end

      def client_content
        <<-EOF
log_level               :auto
log_location            STDOUT
chef_server_url         '#{url}'
validation_client_name  '#{validator_name}'
# Using default node name (fqdn)
        EOF
      end

      def knife_content
        <<-EOF
log_level                :info
log_location             STDOUT
node_name                '#{client_name}'
client_key               '/root/.chef/#{client_name}.pem'
validation_client_name   '#{validator_name}'
validation_key           '/etc/chef/validation.pem'
chef_server_url          '#{url}'
cache_type               'BasicFile'
cache_options( :path => '/root/.chef/checksums' )
        EOF
      end

      class ChefDelegator < Stork::Resource::Delegator
        file :client_key
        file :validation_key

        def url(url)
          delegated.url = url
        end

        def version(version)
          delegated.version = version
        end

        def client_name(client_name)
          delegated.client_name = client_name
        end

        def validator_name(validator_name)
          delegated.validator_name = validator_name
        end

        def encrypted_data_bag_secret(secret)
          delegated.encrypted_data_bag_secret = secret
        end
      end
    end
  end
end
