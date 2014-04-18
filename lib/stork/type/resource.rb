module Stork
  class Type
    class Resource
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
      end

      def self.create_delegators(klass, name, options)
        fail "A resource must be specified for #{name}" unless options.resource

        klass.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}(name=nil, options = {}, &block)
            klass = Stork::Resource::#{options.resource.capitalize}
            @delegated.#{name} = klass.build(name, options, &block)
          end
        EOS
      end
    end
  end
end
