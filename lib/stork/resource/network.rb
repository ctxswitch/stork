module Stork
  module Resource
    class Network < Base
      attribute :netmask
      attribute :gateway
      attribute :nameserver, type: :array
      attribute :search_path, type: :array
    end
  end
end
