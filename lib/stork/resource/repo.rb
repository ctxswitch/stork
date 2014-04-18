module Stork
  module Resource
    class Repo
      attr_reader :name
      attr_accessor :baseurl
      attr_accessor :mirrorlist

      def initialize(name, options = {})
        @name = name
        @baseurl = options.key?(:baseurl) ? options[:baseurl] : nil
        @mirrorlist = options.key?(:mirrorlist) ? options[:mirrorlist] : nil

        unless baseurl || mirrorlist
          fail SyntaxError, 'One of baseurl or mirrorlist must be specified.'
        end

        if baseurl && mirrorlist
          fail SyntaxError, 'You may use only baseurl or mirrorlist but not both.'
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
