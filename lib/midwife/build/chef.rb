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
        str = <<-CONFIG
log_level              :auto
log_location           STDOUT
chef_server_url        "#{url}"
validation_client_name "#{validator_name}"
CONFIG
      end

      def knife_content
        str = <<-CONFIG
log_level                :info
log_location             STDOUT
node_name                "#{client_name}"
client_key               "/root/.chef/#{client_name}.pem"
validation_client_name   "#{validator_name}"
validation_key           "/etc/chef/validation.pem"
chef_server_url          "#{url}"
cache_type               "BasicFile"
cache_options( :path => "/root/.chef/checksums" )
CONFIG
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