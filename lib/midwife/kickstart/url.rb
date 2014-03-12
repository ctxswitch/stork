module Midwife
  module Kickstart
    class Url < Command
      name 'url'
      option 'url'
      option 'mirrorlist'
      option 'proxy'
      option 'noverifyssl', boolean: true, default: false
    end
  end
end