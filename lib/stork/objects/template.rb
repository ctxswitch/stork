module Stork
  module Objects
    class Template < Base
      attr_reader :name
      attr_reader :content

      def initialize(path)
        @name = File.basename(path, '.ks.erb')
        @content = read_content(path)
      end

      alias_method :id, :name

    private
      def read_content(path)
        File.read(path)
      end
    end
  end
end
