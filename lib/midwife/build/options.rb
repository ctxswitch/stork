module Midwife
  module Build
    class Options
      def intialize
      end

      def errors
        @errors ||= []
      end

      def []=(key, opt)
        options[key] = opt
      end

      def [](key)
        options[key]
      end

      def options
        @options ||= Hash.new
      end

      def all
        options
      end

      def set
        opts = options.keep_if{ |k,o| not o.value.nil? }.sort_by{ |k,v| k }
        opts.each do |opt|
          yield opt[0], opt[1]
        end
      end

      def validate
        set do |key, option|
          errors << option.message unless option.valid?
        end
      end
    end

    class Option
      attr_accessor :default, :type, :validate, :required

      def initialize
        @default = nil
        @type = :string
        @validate = nil
        @value = nil
        @required = false 
      end

      def valid?
        if value
          case type
          when :boolean
            [1,0,'1','0','true','false',true,false].include?(value)
          else
            value.is_a?(type_class)
          end
        else
          true
        end
      end

      def message
        "#{type} required"
      end

      def is_set?
        !@value.nil?
      end

      def value
        @value
      end

      def value=(val)
        @value = val
      end

      def type_class
        case type
        when :boolean
          nil
        when :string
          String
        when :integer
          Integer
        else
          raise Midwife::TypeError.new("Unsupported type :#{type}")
        end
      end

      def convert(val)
        if val
          case type
          when :boolean
            [1,'1','true',true].include?(val)
          when :integer
            val.to_i
          else
            val.to_s
          end
        end
      end
    end
  end
end
