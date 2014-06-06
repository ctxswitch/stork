require 'sinatra'
require 'json'
require 'rack'
require 'thin'

module Stork
  module Server
    class Control
      def self.start(configuration)
        puts "Starting stork server on port #{configuration.port}."
        app = Stork::Server::Application
        app.set :config, configuration
        app.set :collection, Stork::Builder.load(configuration).collection

        @thin = Thin::Server.new(configuration.bind, configuration.port, app)
        @thin.tag = "Stork #{VERSION}"
        unless ENV['RACK_ENV'] == 'test'
          @thin.pid_file = configuration.pid_file
          @thin.log_file = configuration.log_file
          @thin.daemonize
        else
          puts '!!! Running in test mode'
        end
        @thin.start
      end

      def self.stop(configuration)
        puts 'Stoping the stork server.'
        Thin::Server.kill(configuration.pid_file)
      end

      def self.restart(configuration)
        stop(configuration)
        start(configuration)
      end
    end
  end
end
