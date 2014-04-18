module Stork
  module Resource
    class Network < Base
      attribute :netmask
      attribute :gateway
      attribute :nameserver, type: :array
      attribute :search_path, type: :array

      def initialize(name=nil, options = {})
        @name = name
        @netmask = nil
        @gateway = nil
        @nameservers = []
        @search_paths = []
      end
    end
  end
end
