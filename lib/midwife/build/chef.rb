module Midwife
  module Build
    class Chef
      include Midwife::Core
      attr_reader :name, :version, :url, :client_name, :client_key, :run_list
      attr_reader :validator_name, :validation_key, :encrypted_data_bag_secret

      def initialize(name)
        @name = name
        @version = "11.4.4"
        @url = "https://localhost"
        @client_name = "root"
        @client_key = ""
        @validator_name = "chef-validator"
        @validation_key = ""
        @encrypted_data_bag_secret = nil
        @run_list = nil
      end

      def set_version(ver)
        @version = ver
      end

      def set_url(u)
        @url = u
      end

      def set_client_name(name)
        @client_name = name
      end

      def set_client_key(key)
        @client_key = File.read(key)
      end

      def set_validator_name(name)
        @validator_name = name
      end

      def set_validation_key(key)
        @validation_key = File.read(key)
      end

      def set_encrypted_data_bag_secret(secret)
        @encrypted_data_bag_secret = secret
      end

      def config_content
        str = ""
        str += "log_level              :auto\n"
        str += "log_location           STDOUT\n"
        str += "chef_server_url        '#{url}'\n"
        str += "validation_client_name '#{validator_name}'\n"
        str
      end

      def knife_content
        str = ""
        str += "log_level                :info\n"
        str += "log_location             STDOUT\n"
        str += "node_name                '#{client_name}'\n"
        str += "client_key               '/root/.chef/#{client_name}.pem'\n"
        str += "validation_client_name   '#{validator_name}'\n"
        str += "validation_key           '/etc/chef/validation.pem'\n"
        str += "chef_server_url          '#{url}'\n"
        str += "cache_type               'BasicFile'\n"
        str += "cache_options( :path => '/root/.chef/checksums' )\n"
      end

      def first_boot_content
        run_list = {'run_list' => @run_list }
        run_list.to_json
      end

      def emit(hostname, run_list)
        @hostname = hostname
        @run_list = run_list
        template = File.dirname(__FILE__) + '/../erbs/chef_bootstrap.erb'
        renderer = ERB.new(File.read(template))
        renderer.result(binding())
      end

      def self.build(name, &block)
        chef = new(name)
        delegator = ChefDelegator.new(chef)
        delegator.instance_eval(&block)
        chef
      end

      class ChefDelegator < SimpleDelegator
        def version(ver)
          set_version(ver)
        end

        def url(u)
          set_url(u)
        end

        def client_name(name)
          set_client_name(name)
        end

        def client_key(key)
          set_client_key(key)
        end

        def validator_name(name)
          set_validator_name(name)
        end

        def validation_key(key)
          set_validation_key(key)
        end

        def encrypted_data_bag_secret(secret)
          set_encrypted_data_bag_secret(secret)
        end
      end
    end
  end
end