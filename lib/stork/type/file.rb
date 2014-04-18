module Stork
  class Type
    class File < Default
      def self.create_delegators(klass, name, options)
        klass.class_eval <<-EOS, __FILE__, __LINE__
          def #{name}(value)
            @delegated.#{name} = ::File.read(value)
          end
        EOS
      end
    end
  end
end