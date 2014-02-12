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
          # s = Midwife::Server::Application
          @thin = Thin::Server.new("0.0.0.0", 9293, Midwife::Server::Application)
          @thin.tag = "Midwife #{VERSION}"
          unless ENV['RACK_ENV'] == "test"
            @thin.pid_file = File.dirname(__FILE__) + "/../../../tmp/midwife.pid"
            @thin.log_file = File.dirname(__FILE__) + "/../../../log/midwife.log"
            @thin.daemonize
          end
          @thin.start
        end

        def stop
          puts "Stoping the midwife server."
          pid_file = File.dirname(__FILE__) + "/../../../tmp/midwife.pid"
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