module Midwife
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :path, :server, :pxe_path

    def initialize
      @path = "/etc/midwife"
      @server = "localhost"
      @pxe_path = "/var/lib/tftpboot/pxelinux.cfg"
    end
  end
end