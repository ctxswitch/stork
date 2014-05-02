module Stork
  module Resource
    class Repo < Base
      attr_accessor :baseurl
      attr_accessor :mirrorlist

      def setup
        @baseurl = options.key?(:baseurl) ? options[:baseurl] : nil
        @mirrorlist = options.key?(:mirrorlist) ? options[:mirrorlist] : nil
      end

      def validate!
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

      class RepoDelegator < Stork::Resource::Delegator ; end
    end
  end
end
