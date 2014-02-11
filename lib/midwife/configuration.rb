module Midwife
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :path, :server

    def initialize
      @path = "/etc/midwife"
      @server = "localhost"
    end
  end
end