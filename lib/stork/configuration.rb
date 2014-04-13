module Stork
  class Configuration
    attr_accessor :path
    attr_accessor :bundle_path
    attr_accessor :authorized_keys_file
    attr_accessor :pxe_path
    attr_accessor :log_file
    attr_accessor :pid_file
    attr_accessor :server
    attr_accessor :port
    attr_accessor :bind
    attr_accessor :timezone

    def initialize
      @path                 = "/etc/stork"
      @authorized_keys_file = path + "/authorized_keys"
      @bundle_path          = path + "/bundles"

      @pxe_path             = "/var/lib/tftpboot/pxelinux.cfg"
      @log_file             = "/var/log/stork.log"
      @pid_file             = "/var/run/stork.pid"

      @server               = "localhost"
      @port                 = 9293
      @bind                 = "0.0.0.0"
      @timezone             = "America/Los_Angeles"
    end

    def hosts_path
      bundle_path + "/hosts"
    end

    def snippets_path
      bundle_path + "/snippets"
    end

    def layouts_path
      bundle_path + "/layouts"
    end

    def networks_path
      bundle_path + "/networks"
    end

    def distros_path
      bundle_path + "/distros"
    end

    def templates_path
      bundle_path + "/templates"
    end

    def chefs_path
      bundle_path + "/chefs"
    end

    def to_file
      <<-EOS
# Stork configuration file"
path                    "#{path}"
bundle_path             "#{bundle_path}"
authorized_keys_file    "#{authorized_keys_file}"
pxe_path                "#{pxe_path}"
log_file                "#{log_file}"
pid_file                "#{pid_file}"
server                  "#{server}"
port                    #{port}
bind                    "#{bind}"
timezone                "#{timezone}"
      EOS
    end

    def self.from_file(filename)
      find_or_create(filename)
    end

    def self.find_or_create(filename)
      config = new
      if File.exist?(filename)
        delegator = ConfigDelegator.new(config)
        delegator.instance_eval(File.read(filename), filename)
      else
        File.open(filename, 'w') { |file| file.write(config.to_file) }
      end
      config
    end

    class ConfigDelegator
      def initialize(obj)
        @delegated = obj
      end

      def method_missing(meth, *args)
        @delegated.send("#{meth.to_s}=", *args)
      end
    end
  end
end