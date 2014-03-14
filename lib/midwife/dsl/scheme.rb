module Midwife
  module DSL
    class Scheme
      include Base
      allow_objects :partition
      boolean :zerombr
      boolean :clearpart
      partition :partition, multi: true
    end
  end
end
