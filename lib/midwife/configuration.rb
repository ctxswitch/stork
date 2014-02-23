module Midwife
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :path, :server, :pxe_path, :authorized_keys, :ntp_server, :log_file
    attr_accessor :pid_file

    def initialize
      @path = "/etc/midwife"
      @server = "localhost"
      @pxe_path = "tmp/tftpboot/pxelinux.cfg"
      @log_file = "tmp/log/midwife.log"
      @pid_file = "tmp/run/midwife.pid"
      @authorized_keys = ""
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

      def authorized_keys(pubfile)
        @delegated.authorized_keys = File.read(pubfile)
      end

      def method_missing(meth, *args)
        @delegated.send("#{meth.to_s}=", *args)
      end
    end
  end
end