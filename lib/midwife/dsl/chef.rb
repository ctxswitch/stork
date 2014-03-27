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
