module Midwife
  module Kickstart
    class Clearpart < Command
      name 'clearpart'
      option 'all', boolean: true, default: true
      option 'initlabel', boolean: true, default: true
    end
  end
end
