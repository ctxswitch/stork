module Stork
  module Resource
    class Distro < Base
      attr_accessor :kernel
      attr_accessor :image
      attr_accessor :url

      def hashify
        attrs = {}
        attrs['kernel'] = kernel
        attrs['image'] = image
        attrs['url'] = url
      end

      class DistroDelegator < Stork::Resource::Delegator
        def kernel(kernel)
          delegated.kernel = kernel
        end

        def image(image)
          delegated.image = image
        end

        def url(url)
          delegated.url = url
        end
      end
    end
  end
end
