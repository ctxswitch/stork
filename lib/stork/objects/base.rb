module Stork
  module Objects
    class Base
      attr_reader :attributes

      def self.attributes
        @attributes ||= []
      end

      def self.attr_accessor(*args)
        attributes.concat args
        super(*args)
      end

      def self.db_load
        raise "Not Implemented"
      end

      def self.db_table
        raise "Not Implemented"
      end

      def db_insert
        raise "Not Implemented"
      end
    end
  end
end