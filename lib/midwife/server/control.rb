require 'sinatra'
require 'json'
require 'rack'
require 'thin'

module Midwife
  module Server
    class Control
      class << self
        def start
          puts "Starting midwife server on port 9293."
          @thin = Thin::Server.new("0.0.0.0", 9293, Midwife::Server::Application)
          @thin.tag = "Midwife #{VERSION}"
          unless ENV['RACK_ENV'] == "test"
            @thin.pid_file = Midwife.configuration.pid_file
            @thin.log_file = Midwife.configuration.log_file
            @thin.daemonize
          else
            puts "Running in test mode"
          end
          @thin.start
        end

        def stop
          puts "Stoping the midwife server."
          pid_file = Midwife.configuration.pid_file
          Thin::Server.kill(pid_file)
        end

        def restart
          stop
          start
        end
      end
    end
  end
end