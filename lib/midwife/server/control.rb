require 'sinatra'
require 'json'
require 'rack'
require 'thin'

module Midwife
  module Server
    class Control
      class << self
        def start(config)
          puts "Starting midwife kickstart server."
          s = Midwife::Server::Application
          s.set :config, config
          s.set :config_path, config.path
          s.set :views_path, config.views_path
          s.set :hosts_path, config.hosts_path
          s.set :templates_path, config.templates_path 
          s.set :kickstart_path, config.kickstart_path
          s.set :environment, config.mode
          s.set :logging, true
          @thin = Thin::Server.new("0.0.0.0", 9293, Midwife::Server)
          @thin.tag = "Midwife #{VERSION}"
          if Midwife.env == "production"
            @thin.pid_file = "/tmp/midwife.pid"
            @thin.log_file = "./log/midwife.log"
            @thin.daemonize
          end
          @thin.start
        end

        def stop(config)
          puts "Stoping the midwife server."
          pid_file = "/tmp/midwife.pid"
          Thin::Server.kill(pid_file)
        end

        def restart(config)
          stop(config)
          start(config)
        end
      end
    end
  end
end