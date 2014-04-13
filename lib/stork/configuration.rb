module Stork
  class Configuration
    attr_accessor :etc
    attr_accessor :bundle_path
    attr_accessor :hosts_path
    attr_accessor :snippets_path
    attr_accessor :layouts_path
    attr_accessor :networks_path
    attr_accessor :distros_path
    attr_accessor :templates_path
    attr_accessor :chefs_path
    attr_accessor :authorized_keys_file
    attr_accessor :var
    attr_accessor :pxe_path
    attr_accessor :log_file
    attr_accessor :tmp
    attr_accessor :pid_file
    attr_accessor :server
    attr_accessor :port
    attr_accessor :bind
    attr_accessor :timezone

    def initialize
      @etc                  = "/etc/stork"
      @bundle_path          = etc + "/bundle"
      @hosts_path           = bundle_path + "/hosts"
      @snippets_path        = bundle_path + "/snippets"
      @layouts_path         = bundle_path + "/layouts"
      @networks_path        = bundle_path + "/networks"
      @authorized_keys_file = bundle_path + "/keys/authorized_keys"
      @distros_path         = bundle_path + "/distros"
      @templates_path       = bundle_path + "/templates"
      @chefs_path           = bundle_path + "/chefs"

      @var                  = "/var"
      @pxe_path             = var + "/lib/tftpboot/pxelinux.cfg"
      @log_file             = var + "/log/stork.log"
      @pid_file             = var + "/run/stork.pid"

      @server               = "localhost"
      @port                 = 9293
      @bind                 = "0.0.0.0"
      @timezone             = "America/Los_Angeles"
    end

    def to_small
      <<-EOS
# Stork configuration file"
etc                     "#{etc}"
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
        File.open(filename, 'w') { |file| file.write(config.to_s) }
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