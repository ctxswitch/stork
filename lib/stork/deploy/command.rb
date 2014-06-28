module Stork
  module Deploy
    class Command
      def initialize(name, value)
        @name = name
        @value = value
        @options = Array.new
      end

      def to_s
        command_str = @name
        command_str << " #{@value}" if @value
        if @options.empty?
          command_str << "\n"
        else
          command_str << " #{@options.join(' ')}\n"
        end
      end

      def boolean(opt, value)
        @options << "--#{opt}" if value
      end

      def option(opt, value)
        if value.is_a?(Array)
          @options << "--#{opt}=#{value.join(',')}" unless value.empty?
        else
          @options << "--#{opt}=#{value}" if value
        end
      end

      def option_no_equal(opt, value)
        if value.is_a?(Array)
          @options << "--#{opt} #{value.join(',')}" unless value.empty?
        else
          @options << "--#{opt} #{value}" if value
        end
      end

      def yes_no(opt, value)
        @options << "--#{opt}=#{value ? 'yes' : 'no'}" if value
      end

      def either_or(opt, alt, value)
        @options << "--#{value ? opt : alt}"
      end

      def multi(opt, values)
        values.each do |value|
          @options << "--#{opt}=#{value}"
        end
      end

      def value(value)
        @value = value
      end

      def self.create(name, value=nil, &block)
        command = new(name, value)
        yield command if block_given?
        # puts "COMM: #{command.inspect}"
        # puts "COMS: #{command.to_s}"
        command.to_s
      end
    end
  end
end