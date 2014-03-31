module Midwife
  module DSL
    class Chef
      attr_reader :name
      attr_accessor :url
      attr_accessor :version
      attr_accessor :client_key
      attr_accessor :client_name
      attr_accessor :validator_name
      attr_accessor :validation_key
      attr_accessor :encrypted_data_bag_secret

      def initialize(name)
        @name = name
        @url = nil
        @version = nil
        @client_key = nil
        @client_name = nil
        @validator_name = nil
        @validation_key = nil
        @encrypted_data_bag_secret = nil
      end

      def client_content
        lines = []
        lines << "log_level        :auto"
        lines << "log_location     STDOUT"
        lines << "chef_server_url  \"#{url}\""
        lines << "validation_client_name \"#{validator_name}\""
        lines << "# Using default node name (fqdn)"
        lines.join("\n")
      end

      def knife_content
        lines = []
        "log_level                :info"
        "log_location             STDOUT"
        "node_name                \"#{client_name}\""
        "client_key               \"/root/.chef/#{client_name}.pem\""
        "validation_client_name   \"#{validator_name}\""
        "validation_key           \"/etc/chef/validation.pem\""
        "chef_server_url          \"#{url}\""
        "cache_type               \"BasicFile\""
        "cache_options( :path => \"/root/.chef/checksums\" )"
        lines.join("\n")
      end

      def self.build(name, &block)
        chef = new(name)
        delegator = ChefDelegator.new(chef)
        delegator.instance_eval(&block)
        chef
      end

      class ChefDelegator
        def initialize(obj)
          @delegated = obj
        end

        def url(value)
          @delegated.url = value
        end

        def version(value)
          @delegated.version = value
        end

        def client_key(value)
          @delegated.client_key = File.read(value)
        end

        def client_name(value)
          @delegated.client_name = value
        end

        def validator_name(value)
          @delegated.validator_name = value
        end

        def validation_key(value)
          @delegated.validation_key = File.read(value)
        end

        def encrypted_data_bag_secret(value)
          @delegated.encrypted_data_bag_secret = value
        end
      end

      alias_method :id, :name
    end
  end
end
