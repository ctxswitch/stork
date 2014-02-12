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

        h = Midwife::Build::Host.find(host)

        if h
          h.emit
        else
          json_halt_not_found
        end
      end

      get '/runlist/:host' do |host|
        info "#{host} requested runlist"
        h = Midwife::Build::Host.find(host)

        if h
          h.emit_run_list
        else
          json_halt_not_found
        end
      end

      get '/notify/:host/installed' do |host|
        info "#{host} has notified completed install"
        h = Midwife::Build::Host.find(host)

        if h
          h.set_localboot
          json_halt_ok
        else
          json_halt_not_found
        end
      end

      get '/notify/:host/install' do |host|
        info "install requested for #{host}"
        h = Midwife::Build::Host.find(host)

        if h
          h.set_install
          json_halt_ok
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

        # def json_halt_internal_error
        #   json_halt 500, 500, "Internal error"
        # end

        def json_halt_not_found
          json_halt 404, 404, "not found"
        end

        # def json_halt_parse_error
        #   json_halt 404, 404, "There was a problem parsing the configuration file"
        # end
      end
    end
  end
end
