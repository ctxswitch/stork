module Stork
  class Type
    class Collection
      def self.create_accessors(klass, name, options)
        fail "A resource must be specified for #{name}" unless options.resource

        klass.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}=(value)
            @#{name} = value
          end

          def #{name}
            @#{name} ||= Stork::Resource::#{options.resource.capitalize}.new
          end
        EOS

        options.forward.each do |meth|
          klass.class_eval <<-EOS, __FILE__, __LINE__
            def #{meth}
              #{name}.#{meth}
            end
          EOS
        end
      end

      def self.create_delegators(klass, name, options)
        fail "A resource must be specified for #{name}" unless options.resource

        klass.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}(value)
            obj = collection.#{name}.get(value)
            raise SyntaxError, "Could not find #{options.resource} " + value unless obj
            @delegated.#{name} = obj
          end
        EOS

        options.forward.each do |meth|
          klass.class_eval <<-EOS, __FILE__, __LINE__
            def #{meth}(value)
              @delegated.#{name}.#{meth} = value
            end
          EOS
        end
      end
    end
  end
end
