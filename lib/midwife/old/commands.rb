require 'optparse'
require 'pp'
require 'erb'

module Midwife
  class Commands
    def initialize(args)
      @args = args
      @config = Midwife::Config.new()
      @path = @config.path
      @mode = @config.mode
      $logger = Rack::Logger.new(STDERR)
    end

    # Everything that is passed to here must be option=value format
    def options_to_hash(pairs)
      h = {}
      pairs.each do |pair|
        key, value = pair.split('=')
        raise "Invalid option/value.  All arguments must be in the format key=value" unless key && value
        h[key] = value
      end
      h
    end

    def execute
      extra = {}
      command = @args.shift
      raise "Invalid Command #{command}" unless command

      case command
      when "kick"
        extra['host'] = @args.pop
      when "server"
        extra['action'] = @args.pop
      when "pxe"
        host = @args.pop
        extra['host'] = host
        extra['action'] = @args.pop
      # when "xen"
      #   host = @args.pop
      #   extra['host'] = host
      #   extra['action'] = @args.pop
      else
        puts "Invalid Command"
        exit(false)
      end

      send(command,extra)
    end

    def kick(*args)
      require 'json'
      raise "No host specified" unless args[0].include?('host')
      @config.load(args[0]['host'])
      puts Midwife::Kickstart.new(@config).generate
    end

    def pxe(*args)
      host = args[0]['host']
      action = args[0]['action']
      @config.load(host)
      pxe = Midwife::PXE.new(@config)
      pxe.send(action)
    end

    # Stub for automating xenserver
    # def xen(*args)
    #   host = args[0]['host']
    #   action = args[0]['action']
    #   @config.load(host)
    #   xcp = Midwife::Xentools.new(@config)
    #   case action
    #   when "install"
    #     xcp.vminstall
    #   when "destroy"
    #     xcp.vmdestroy
    #     puts "not implemented"
    #     exit
    #   else
    #     puts "Unknown action"
    #     exit(false)
    #   end
    # end

    def server(*args)
      host = args[0]['host']
      action = args[0]['action']
      Midwife::ServerCntl.send(action,@config)
    end
  end
end
