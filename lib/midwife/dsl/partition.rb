module Midwife
  module DSL
    class Partition
      include Base
      integer :size
      string :type
      boolean :primary
      boolean :grow
      boolean :recommended
    end
  end
end