module Stork
  module Resource
    class Repo
      attr_reader :name
      attr_accessor :baseurl
      attr_accessor :mirrorlist

      def initialize(name, options = {})
        @name = name
        @baseurl = options.has_key?(:baseurl) ? options[:baseurl] : nil
        @mirrorlist = options.has_key?(:mirrorlist) ? options[:mirrorlist] : nil

        unless baseurl || mirrorlist
          raise SyntaxError, "One of baseurl or mirrorlist must be specified."
        end

        if baseurl && mirrorlist
          raise SyntaxError, "You may use only baseurl or mirrorlist but not both."
        end
      end

      def is_local?
        !(baseurl && mirrorlist)
      end

      def self.build(name, options = {}, &block)
        new(name, options)
      end
    end
  end
end
