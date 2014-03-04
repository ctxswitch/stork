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

      def value( value )
        @value = value
      end

      def get_value
        @value || ""
      end

      def option( name, opts = {})
        options[name] = OpenStruct.new
        options[name].default = opts['default'] || nil
        options[name].type = opts['type'] || :string
        options[name].convert = opts['convert'] || :string
        options[name].validate = opts['validate'] || :string
      end

      def options
        @options ||= {}
      end

      def build(value, &block)
        obj = new
        delegator = BuildDelegator.new(obj, options)
        delegator.instance_eval(&block) if block_given?
        obj
      end

      class BuildDelegator < SimpleDelegator
        def initialize(obj, options)
          @options = options
          super(obj)
        end

        def method_missing( sym, *args, &block )
          if @options[sym]
            puts "hello #{args.inspect}"
          else
            raise "Syntax error."
          end
        end
      end
    end

    def initialize(*args)
    end

    def command
      self.class.get_command
    end

    def value
      self.class.get_value
    end

    def options
      self.class.options
    end

    def options_string
      str = ""
      options.keys.sort.each do |key|
        str += "--#{key.to_s}"
        str += "=#{options[key]} "
      end
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

puts p.emit