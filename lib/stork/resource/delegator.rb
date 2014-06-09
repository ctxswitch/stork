module Stork
  module Resource
    class Delegator
      attr_reader :collection
      attr_reader :delegated

      def initialize(inst, options)
        @delegated = inst
        @collection = options[:collection]
      end

      def get_collection_item(name, value)
        obj = collection.send(name).get(value)
        raise SyntaxError, "Could not find #{value} in #{name}" unless obj
        obj
      end

      def self.flag(name, options = {})
        create_boolean_delegators(name, options)
      end

      def self.file(name, options = {})
        create_file_delegators(name, options)
      end

      def self.create_boolean_delegators(name, options)
        negate_name = options.has_key?(:negate) ? options[:negate] : "no#{name}"
        self.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            @delegated.#{name} = true
          end

          def #{negate_name}
            @delegated.#{name} = false
          end
        EOS
      end

      def self.create_file_delegators(name, options)
        self.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}(value)
            @delegated.#{name} = ::File.read(value)
          end
        EOS
      end
    end
  end
end