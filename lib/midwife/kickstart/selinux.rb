module Midwife
  module Kickstart
    class Selinux < Command
      name 'selinux'
      option 'disabled', boolean: true, default: true, unsets: %w{enforcing permissive}
      option 'enforcing', boolean: true, default: false, unsets: %w{disabled permissive}
      option 'permissive', boolean: true, default: false, unsets: %w{disabled enforcing}
    end
  end
end