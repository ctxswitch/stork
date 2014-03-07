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
          opt = Option.new
          opt.default = opts[:default] || nil
          opt.type = opts[:type] || :string
          opt.value = nil
          opt.required = false
          options[name] = opt

          class_eval <<-EOS, __FILE__, __LINE__
            def #{name}
              options[:#{name}].value
            end
          EOS
        end

        def options
          @options ||= Options.new
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
              case @options[sym].type
              when :boolean
                @delegated.options[sym].value = true
              else
                @delegated.options[sym].value = args.first
              end
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
        options.validate
        errors.empty? && options.errors.empty?
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
        options.set do |name, option|
          unless option.value.nil?
            str += "--#{name.to_s}"
            str += case option.type
            when :boolean
              " "
            else
              "=#{option.value.to_s} "
            end
          end
        end
        str.strip
      end

      def emit
        "#{command} #{value} #{options_string}"
      end
    end
  end
end