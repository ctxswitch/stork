module Stork
  module Collection
    class Base
      include Enumerable

      def initialize(*objs)
        @objects = objs
      end

      def size
        @objects.size
      end

      def add(*objs)
        objs.each do |obj|
          validate(obj)
          @objects << obj
        end
      end

      def each(&block)
        @objects.each do |obj|
          block.call(obj)
        end
      end

      def validate(obj)
        true
      end

      # Need to check for nil and raise
      def get(id)
        find { |obj| obj.id == id }
      end

      def hashify
        objs = []
        @objects.each do |obj|
          objs << obj.name
        end
        objs
      end
    end
  end
end
