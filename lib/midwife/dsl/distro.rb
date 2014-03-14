module Midwife
  module DSL
    class Distro
      include Base
      string :url
      string :kernel
      string :initrd
    end
  end
end
