module Stork
  class Type
    class Array
      def self.create_accessors(klass, name, options)
        klass.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}s=(value)
            @#{name} = value
          end

          def #{name}s
            @#{name} ||= []
          end
        EOS
      end

      def self.create_delegators(klass, name, options)
        if options.of == :resources
          fail "A resource must be specified for #{name}" unless options.resource
          resource = options.resource.to_s.split('_').map { |e| e.capitalize }.join

          klass.class_eval <<-EOS, __FILE__, __LINE__
            def #{name}(value = nil, options = {}, &block)
              @delegated.#{name}s << Stork::Resource::#{resource}.build(value, options, &block)
            end
          EOS
        else
          klass.class_eval <<-EOS, __FILE__, __LINE__
            def #{name}(value)
              @delegated.#{name}s << value
            end
          EOS
        end
      end
    end
  end
end
