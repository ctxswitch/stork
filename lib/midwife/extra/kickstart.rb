require 'delegate'

module Kickstart
  class Base
    class << self
      def command( command )
        @command = command
      end

      def get_command
        @command || ""
      end

      def value( name )
        class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            @value
          end
        EOS

        @value = name.to_sym
      end

      def get_value
        @value || :default
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

      def build(value, &block)
        obj = new(value)
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
      @value = args.first unless args.empty?
    end

    def command
      self.class.get_command
    end

    def value
      # self.class.get_value
      @value
    end

    def options
      self.class.options
    end

    def options_string
      str = ""
      options.keys.sort.each do |key|
        str += "--#{key.to_s}"
        str += "=#{options[key].value} " unless options[key].type == :boolean
      end
      str
    end

    def emit
      "#{command} #{value} #{options_string}"
    end
  end
end

class Part < Kickstart::Base
  command :part #, alias: partition
  value :mntpoint #, type: path
  option :fstype
  option :size
end

p = Part.build '/' do
  fstype 'ext4'
  size 1000
end

puts p.mntpoint
puts p.emit

