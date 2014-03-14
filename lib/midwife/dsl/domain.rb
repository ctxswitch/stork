module Midwife
  module DSL
    class Domain
      include Base
      string :ntpserver, multi: true
      string :netmask
      string :gateway
      string :nameserver, multi: true
    end
  end
end
