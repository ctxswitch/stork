module Stork
  class Type
    class Symbol
      def self.create_accessors(klass, name, options)
        default = options.default ? options.default : :unset
        klass.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}=(value)
            @#{name} = value
          end

          def #{name}
            @#{name} ||= :#{default}
          end
        EOS
      end

      def self.create_delegators(klass, name, options)
        klass.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}(value)
            @delegated.#{name} = value
          end
        EOS
      end
    end
  end
end