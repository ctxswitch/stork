module Stork
  module Resource
    class Firewall < Base
      attribute :enabled, type: :boolean,
                          negate: :disable,
                          default: true
      attribute :ssh,     type: :boolean,
                          default: true
      attribute :telnet,  type: :boolean,
                          default: false
      attribute :smtp,    type: :boolean,
                          default: false
      attribute :http,    type: :boolean,
                          default: false
      attribute :ftp,     type: :boolean,
                          default: false
      attribute :trusted_device,  type: :array,
                                  as: :trusted
      attribute :allowed_port,    type: :array,
                                  as: :allow
    end
  end
end
