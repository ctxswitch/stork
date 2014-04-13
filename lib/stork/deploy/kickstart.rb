module Stork
  module Deploy
    class Kickstart
      def initialize(host, configuration=nil)
        @host = host
        @configuration = configuration
      end

      def render
        renderer = ERB.new(@host.template.content)
        renderer.result(Bindings::Kickstart.new(@configuration, @host).get_binding)
      end
    end
  end
end
