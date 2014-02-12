module Midwife
  module Core
    def builder
      self.class.builder
    end

    module ClassMethods
      def builder
        @@builder ||= Midwife::Builder.build
      end

      def export(builder)
        @@builder = builder
      end

      def find(name)
        builder.find(self, name)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
