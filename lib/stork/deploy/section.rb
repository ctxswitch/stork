module Stork
  module Deploy
    class Section
      def initialize(name, options)
        @name = name
        @options = options
        @contents = []
      end

      def to_s
        if @contents.empty?
          str = ""
        else
          str = "%#{@name}"
          @options.each { |key, value| str += " --#{key}=#{value}" }
          str += "\n"
          str += @contents.join("\n")
          str += "\n%end"
        end
        str
      end

      def content(content)
        @contents << content unless content.empty?
      end

      def self.create(name, opts={}, &block)
        section = new(name, opts)
        yield section if block_given?
        section.to_s
      end
    end
  end
end