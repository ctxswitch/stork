module Midwife
  module DSL
    class Host
      include Base
      allow_objects :distro, :scheme, :net, :chef
      string :template
      string :name
      string :pxemac
      string :timezone
      symbol :selinux
      string :password
      array :run_list
      chef :chef
      net :net, multi: true
      scheme :scheme
      distro :distro
    end
  end
end
