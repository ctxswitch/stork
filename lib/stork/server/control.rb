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

      def start
        @app.set :collection, Stork::Builder.load.collection

        unless is_daemon?
          puts <<-EOH.gsub(/^ {12}/, '')
            >> Starting Stork Server (#{Stork::VERSION})...
            >> WEBrick (#{WEBrick::VERSION}) with Rack (#{Rack.release}) is listening on #{Configuration[:bind]}:#{Configuration[:port]}
            >> Press CTRL+C to stop

          EOH
        else
          emit_process_id
        end

        thread = start_background
        %w[INT TERM].each { |signal| trap_signal(signal) }
        thread.join
      end

      def emit_process_id
        File.open(Configuration[:pid_file], 'w') { |f| f.write(Process.pid) }
      end

      def trap_signal(signal)
        Signal.trap(signal) do
          puts "\n>> Stopping Stork..."
          @server.shutdown
        end
      end

      ####
      # Basic start management borrowed from chef-zero.  Thanks for the
      # heavy lifting!  Could there be a way to utilize any light http 
      # servers (thin, puma, unicorn)?
      ####
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

      def stop
        pid = File.read(Configuration[:pid_file]).to_i
        Process.kill('TERM', pid)
      rescue Errno::ENOENT
        puts "Process ID file not present."
      rescue Errno::ESRCH
        puts "Stork is not running."
      end

      def restart
        stop
        start
      end
    end
  end
end
