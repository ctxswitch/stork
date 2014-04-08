module Midwife
  module DSL
    class Repo
      attr_reader :name
      attr_accessor :baseurl
      attr_accessor :mirrorlist

      def initialize(name, args = {})
        @name = name
        @baseurl = args.has_key?(:baseurl) ? args[:baseurl] : nil
        @mirrorlist = args.has_key?(:mirrorlist) ? args[:mirrorlist] : nil

        if baseurl && mirrorlist
          raise SyntaxError, "You may use only baseurl or mirrorlist but not both"
        end
      end

      def is_local?
        !(baseurl && mirrorlist)
      end
    end
  end
end
