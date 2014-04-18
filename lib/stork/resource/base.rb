module Stork
  module Resource
    class Base
      attr_reader :name

      def initialize(name = nil, options = {})
        @name = name
      end

      def validate!
      end

      def self.attributes
        @attributes ||= []
      end

      def self.attribute_options
        @attribute_options ||= {}
      end

      def self.attribute(name, options = {})
        type      = options.has_key?(:type) ? options[:type] : :default
        as        = options.has_key?(:as) ? options[:as] : nil
        negate    = options.has_key?(:negate) ? options[:negate] : nil
        resource  = options.has_key?(:resource) ? options[:resource] : nil
        forward   = options.has_key?(:forward) ? options[:forward] : []
        of        = options.has_key?(:of) ? options[:of] : :default
        default   = options.has_key?(:default) ? options[:default] : nil

        # Set up the options
        attribute_options[name] = OpenStruct.new
        attribute_options[name].type = type
        attribute_options[name].as = as
        attribute_options[name].negate = negate
        attribute_options[name].resource = resource
        attribute_options[name].forward = forward
        attribute_options[name].of = of
        attribute_options[name].default = default

        # Add the attribute and create the accessors
        attributes << name

        klass = Stork::Type::const_get(type.to_s.capitalize)
        klass.create_accessors(self, name, attribute_options[name])
      end

      def self.build(name=nil, options = {}, &block)
        inst = new(name, options)
        delegator = Delegator.setup(attributes, attribute_options).new(inst, options)
        delegator.instance_eval(&block) if block_given?
        inst.validate!
        inst
      end

      alias_method :id, :name

      class Delegator
        attr_reader :collection
        attr_reader :configuration

        def initialize(inst, options)
          @delegated = inst
          @collection = options[:collection]
          @configuration = options[:configuration]
        end

        def self.setup(attributes, attribute_options)
          attributes.each do |name|
            options = attribute_options[name]
            klass = Stork::Type::const_get(options.type.to_s.capitalize)
            klass.create_delegators(self, name, options)
            class_eval "alias_method :#{options.as}, :#{name}" if options.as
          end
          self
        end
      end
    end
  end
end