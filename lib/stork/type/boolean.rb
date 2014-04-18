module Stork
  class Type
    class Boolean
      def self.create_accessors(klass, name, options)
        default = options.default.nil? ? true : options.default
        negate_name = options.negate ? options.negate : "no#{name}"

        klass.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}=(value)
            @#{name} = value
          end

          def #{name}
            @#{name}.nil? ? #{default} : @#{name}
          end

          def #{negate_name}
            !#{name}
          end

          def #{name}?
            #{name}
          end
        EOS
      end

      def self.create_delegators(klass, name, options)
        negate_name = options.negate ? options.negate : "no#{name}"
        klass.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            @delegated.#{name} = true
          end

          def #{negate_name}
            @delegated.#{name} = false
          end
        EOS
      end
    end
  end
end