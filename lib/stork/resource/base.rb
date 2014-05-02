module Stork
  module Resource
    class Base
      attr_reader :name
      attr_reader :options
      attr_reader :configuration

      def initialize(name = nil, options = {})
        @name = name
        @configuration = options[:configuration]
        @options = options
        setup
      end

      def setup
      end

      def validate!
      end

      def require_value(attr)
        fail SyntaxError, "#{attr} is required" if send(attr).nil?
      end

      def self.build(name = nil, options = {}, &block)
        inst = new(name, options)
        klass_name = self.to_s.split('::').last
        klass = const_get("#{klass_name}Delegator")
        delegator = klass.new(inst, options)
        delegator.instance_eval(&block) if block_given?
        inst.validate!
        inst
      end

      alias_method :id, :name
    end
  end
end
