require 'sinatra'
require 'json'
require 'rack'
require 'webrick'

module Stork
  module Server
    class Control
      def initialize(configuration, options)
        @configuration = configuration
        @app = Stork::Server::Application
        # @thin = Thin::Server.new(@configuration.bind, @configuration.port, app)
        @daemonize = options.daemonize
      end

      # Basic start management borrowed from chef-zero.  Could there be a
      # way to utilize any light http servers (thin, puma, unicorn)?
      def start
        @app.set :config, @configuration
        @app.set :collection, Stork::Builder.load(@configuration).collection

        unless is_daemon?
          puts <<-EOH.gsub(/^ {12}/, '')
            >> Starting Stork Server (#{Stork::VERSION})...
            >> WEBrick (#{WEBrick::VERSION}) with Rack (#{Rack.release}) is listening on #{@configuration.bind}:#{@configuration.port}
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
          :BindAddress => @configuration.bind,
          :Port =>        @configuration.port,
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
        # Do not return until the web server is genuinely started.
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
          # ChefZero::Log.error("Chef Zero did not stop within #{wait} seconds! Killing...")
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
