require "ipaddr"

module Stork
  module Resource
    class Base
      attr_reader :name
      attr_reader :options

      def initialize(name = nil, options = {})
        @name = name
        @options = options
        setup
      end

      def setup
      end

      def validate!
      end

      def hashify
        {'name' => @name}
      end

      def require_value(attr)
        fail SyntaxError, "#{attr} is required" if send(attr).nil?
      end

      def require_valid_ips(attr)
        values = send(attr)
        values.each do |value|
          fail SyntaxError, "#{value} is not a valid address" unless is_valid_ip?(value)
        end
      end

      def require_valid_ip(attr)
        value = send(attr)
        if value
          fail SyntaxError, "#{value} is not a valid address" unless is_valid_ip?(value)
        end
      end

      def is_valid_ip?(ipaddr)
        begin
          IPAddr.new ipaddr
          true
        rescue IPAddr::InvalidAddressError
          false
        end
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
