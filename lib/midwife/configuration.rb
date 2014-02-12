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
      @chef_version = "11.4.4"
      @chef_server_url = "https://localhost"
      @chef_validator = "chef-validator"
      @chef_validation_key = ""
      @chef_client_name = "root"
      @chef_client_key = ""
    end
  end
end