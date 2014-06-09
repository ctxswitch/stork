require 'sinatra'
require 'json'
require 'rack'
require 'webrick'

module Stork
  module Server
    class Control
      def initialize(options)
        @app = Stork::Server::Application
        @daemonize = options.daemonize
      end

      ####
      # Basic start management borrowed from chef-zero.  Thanks for the
      # heavy lifting!  Could there be a way to utilize any light http 
      # servers (thin, puma, unicorn)?
      ####
      def start
        @app.set :collection, Stork::Builder.load.collection

        unless is_daemon?
          puts <<-EOH.gsub(/^ {12}/, '')
            >> Starting Stork Server (#{Stork::VERSION})...
            >> WEBrick (#{WEBrick::VERSION}) with Rack (#{Rack.release}) is listening on #{Configuration[:bind]}:#{Configuration[:port]}
            >> Press CTRL+C to stop

          EOH
        end

        thread = start_background
        %w[INT TERM].each { |signal| trap_signal(signal) }
        thread.join
      end

      def trap_signal(signal)
        Signal.trap(signal) do
          puts "\n>> Stopping Stork..."
          @server.shutdown
        end
      end

      def start_background
        @server = WEBrick::HTTPServer.new(
          :BindAddress => Configuration[:bind],
          :Port =>        Configuration[:port],
          :AccessLog =>   [],
          :Logger =>      WEBrick::Log.new(StringIO.new, 7),
          :StartCallback => proc { @running = true }
        )
        @server.mount('/', Rack::Handler::WEBrick, @app)

        @thread = Thread.new do
          begin
            Thread.current.abort_on_exception = true
            @server.start
          ensure
            @running = false
          end
        end
        
        while !@running && @thread.alive?
          sleep(0.01)
        end
        @thread
      end

      def is_daemon?
        @daemonize
      end

      def stop(wait = 5)
        if @running
          @server.shutdown
          @thread.join(wait)
        end
      rescue Timeout::Error
        if @thread
          puts "Stork did not stop within #{wait} seconds! Killing..."
          @thread.kill
        end
      ensure
        @server = nil
        @thread = nil
      end

      def restart
        stop
        start
      end
    end
  end
end
