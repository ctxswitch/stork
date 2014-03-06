module Midwife
  module Build
    class Base
      class << self
        def command( command )
          @command = command
        end

        def get_command
          @command || ""
        end

        def value( name, opts = {} )
          class_eval <<-EOS, __FILE__, __LINE__
            def #{name}
              @value
            end
          EOS

          @value_required = opts[:required] || false
          @value = name.to_sym
        end

        def get_value
          @value ||= :default
        end

        def value_required?
          @value_required
        end

        def option( name, opts = {})
          options[name] = OpenStruct.new
          options[name].default = opts['default'] || nil
          options[name].type = opts['type'] || :string
          options[name].convert = opts['convert'] || :string
          options[name].validate = opts['validate'] || :string
          options[name].value = nil

          class_eval <<-EOS, __FILE__, __LINE__
            def #{name}
              options[:#{name}].value
            end
          EOS
        end

        def options
          @options ||= {}
        end

        def build(*args, &block)
          obj = new(*args)
          delegator = BuildDelegator.new(obj, options)
          delegator.instance_eval(&block) if block_given?
          obj
        end

        class BuildDelegator < SimpleDelegator
          def initialize(obj, options)
            @options = options
            @delegated = obj
            super(obj)
          end

          def method_missing( name, *args, &block )
            sym = name.to_sym
            if @options[sym]
              @delegated.options[sym].value = args.first
            else
              raise "Syntax error. #{name} is not a valid method."
            end
          end
        end
      end

      def initialize(*args)
        if args.empty? and self.class.value_required?
          errors << "A #{self.class.get_value} value is required but was not given."
        else
          @value = args.first
        end
      end

      def valid?
        errors.empty?
      end

      def command
        self.class.get_command
      end

      def errors
        @errors ||= []
      end

      def value
        @value
      end

      def options
        self.class.options
      end

      def options_string
        str = ""
        options.keys.sort.each do |key|
          str += " --#{key.to_s}"
          str += "=#{options[key].value}" unless options[key].type == :boolean
        end
        str
      end

      def emit
        "#{command} #{value} #{options_string}"
      end
    end
  end
end