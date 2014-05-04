module Stork
  module Deploy
    module Commands
      class Section
        def initialize(name, options)
          @name = name
          @options = options
          @contents = Array.new
        end

        def to_s
          str = "%#{@name}"
          @options.each { |key, value| str += " --#{key}=#{value}" }
          str += "\n"
          str += @contents.join("\n")
          str += "\n%end"
          str
        end

        def content(content)
          @contents << content
        end

        def self.create(name, opts={}, &block)
          section = new(name, opts)
          yield section if block_given?
          section.to_s
        end
      end
    end
  end
end