module Midwife
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :path, :server, :pxe_path, :chef_version, :chef_server_url
    attr_accessor :chef_validator, :chef_validation_key, :chef_client_name
    attr_accessor :chef_client_key, :ssh_pubkeys, :ntp_server, :log_file
    attr_accessor :pid_file

    def initialize
      @path = "/etc/midwife"
      @server = "localhost"
      @pxe_path = "tmp/tftpboot/pxelinux.cfg"
      @log_file = "tmp/log/midwife.log"
      @pid_file = "tmp/run/midwife.pid"
      @chef_version = "11.4.4"
      @chef_server_url = "https://localhost"
      @chef_validator = "chef-validator"
      @chef_validation_key = ""
      @chef_client_name = "root"
      @chef_client_key = ""
      @ssh_pubkeys = []
      @ntp_server = "pool.ntp.org"
    end

    def from_file(filename)
      delegator = ConfigDelegator.new(self)
      delegator.instance_eval(File.read(filename), filename)
    end

    class ConfigDelegator < SimpleDelegator
      def initialize(obj)
        super
        @delegated = obj
      end

      def method_missing(meth, *args)
        @delegated.send("#{meth.to_s}=", *args)
      end
    end
  end
end