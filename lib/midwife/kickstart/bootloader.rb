module Midwife
  module Kickstart
    class Bootloader < Command
      name 'bootloader'
      option 'location', default: 'mbr'
    end
  end
end