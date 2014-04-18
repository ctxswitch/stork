module Stork
  module Resource
    class Distro < Base
      attribute :kernel
      attribute :image
      attribute :url
    end
  end
end
