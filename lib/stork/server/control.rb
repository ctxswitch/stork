require 'sinatra'
require 'json'
require 'rack'
require 'thin'

module Stork
  module Server
    class Control
      def self.start(configuration, collection)
        puts "Starting stork server on port #{configuration.port}."
        app = Stork::Server::Application
        app.set :collection, collection
        app.set :config, configuration

        @thin = Thin::Server.new(configuration.bind, configuration.port, app)
        @thin.tag = "Stork #{VERSION}"
        unless ENV['RACK_ENV'] == "test"
          @thin.pid_file = configuration.pid_file
          @thin.log_file = configuration.log_file
          @thin.daemonize
        else
          puts "!!! Running in test mode"
        end
        @thin.start
      end

      def self.stop(configuration, collection)
        puts "Stoping the stork server."
        Thin::Server.kill(configuration.pid_file)
      end

      def self.restart(configuration, collection)
        stop(configuration, collection)
        start(configuration, collection)
      end
    end
  end
end
