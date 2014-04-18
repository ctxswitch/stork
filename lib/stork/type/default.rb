module Stork
  class Type
    class Default
      def self.create_accessors(klass, name, options)
        klass.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}=(value)
            @#{name} = value
          end

          def #{name}
            @#{name}
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
