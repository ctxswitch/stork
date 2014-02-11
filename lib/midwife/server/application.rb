require "sinatra"

module Midwife
  module Server
    class Application < Sinatra::Base
      include Midwife::Core
      configure do
        enable :logging
      end

      before do
        logger.datetime_format = "%Y/%m/%d @ %H:%M:%S "
        logger.level = Logger::INFO
      end

      get '/' do
        info "GET /"
        json_halt 200, 200, "Midwife Version #{VERSION} - #{CODENAME}"
      end

      get '/ks/:host' do |host|
        info "#{host} requested kickstart"

        host = hosts.find(host)

        if host
          host.emit
        else
          json_halt_not_found
        end
      end

      # get '/notify/:host/installed' do |host|
      #   logger.info "[#{request.ip}] GET /notify/#{host}/installed"
      #   logger.info "#{host} has notified: install complete."
      #   begin
      #     config = settings.config
      #     config.load(host)
      #     p = Midwife::PXE.new(config)
      #     p.boot
      #     json_halt_ok
      #   rescue Errno::ENOENT
      #     json_halt_not_found
      #   end
      # end

      # get '/runlist/:host' do |host|
      #   logger.info "[#{request.ip}] GET /runlist/#{host}"
      #   begin
      #     config = settings.config
      #     config.load(host)
      #     run_list = config.template['run_list']
      #     logger.info "#{host} has requested runlist: #{config.template['run_list'].inspect}"
      #     erb :runlist, :locals => {:run_list => run_list}, :views => settings.views_path, :content_type => "application/json"
      #   rescue Errno::ENOENT
      #     json_halt_not_found
      #   end
      # end

      helpers do
        def info(msg)
          logger.info "[#{request.ip}] INFO: #{msg}"
        end

        def json_halt(request_status, op_status, message)
          halt request_status, {'Content-Type' => 'application/json'}, "{ \"status\":\"#{op_status}\", \"message\": \"#{message}\" }"
        end

        def json_halt_ok
          json_halt 200, 200, "OK"
        end

        def json_halt_internal_error
          json_halt 500, 500, "Internal error"
        end

        def json_halt_not_found
          json_halt 404, 404, "not found"
        end

        def json_halt_parse_error
          json_halt 404, 404, "There was a problem parsing the configuration file"
        end
      end
    end
  end
end
