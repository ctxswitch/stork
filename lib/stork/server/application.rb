require 'sinatra'

module Stork
  module Server
    class Application < Sinatra::Base
      configure do
        enable :logging
        mime_type :plain, 'text/plain'
        mime_type :json, 'application/json'
      end

      before do
        logger.datetime_format = '%Y/%m/%d @ %H:%M:%S '
        logger.level = Logger::INFO
      end

      get '/' do
        info 'GET /'
        json_halt 200, 200, "Stork Version #{VERSION} - #{CODENAME}"
      end

      get '/api/v1/reload' do
        reload_collection
      end

      get '/api/v1/hosts' do
        h = {'hosts' => hosts.hashify}
        json_halt_ok_with_content(h.to_json)
      end

      get '/api/v1/host/:host' do |host|
        h = hosts.get(host)
        json_halt_ok_with_content(h.hashify.to_json)
      end

      get '/host/:host' do |host|
        info "#{host} requested kickstart"

        h = hosts.get(host)

        if h
          # hmm, should the host deploy?
          ks = Stork::Deploy::InstallScript.new(h) # we will be passing the type in shortly
          content_type :plain
          ks.render
        else
          json_halt_not_found
        end
      end

      get '/host/:host/installed' do |host|
        info "#{host} has notified completed install"
        h = hosts.get(host)

        if h
          set_localboot(h)
          json_halt_ok
        else
          json_halt_not_found
        end
      end

      get '/host/:host/install' do |host|
        info "install requested for #{host}"
        h = hosts.get(host)

        if h
          set_install(h)
          json_halt_ok
        else
          json_halt_not_found
        end
      end

      not_found do
        json_halt_not_found
      end

      helpers do
        def hosts
          settings.collection.hosts
        end

        def config
          settings.config
        end

        def collection
          settings.collection
        end

        def reload_collection
          settings.collection = Stork::Builder.load(config).collection
          json_halt 200, 200, 'OK'
        end

        def set_localboot(host)
          pxe(host).localboot
        end

        def set_install(host)
          pxe(host).install
        end

        def pxe(host)
          Stork::PXE.new(host, host.stork, config.port)
        end

        def info(msg)
          logger.info "[#{request.ip}] INFO: #{msg}"
        end

        def json_halt(request_status, op_status, message)
          content_type :json
          halt request_status, { 'Content-Type' => 'application/json' }, "{ \"status\":\"#{op_status}\", \"message\": \"#{message}\" }"
        end

        def json_halt_ok
          content_type :json
          json_halt 200, 200, 'OK'
        end

        def json_halt_ok_with_content(content)
          content_type :json
          halt 200, { 'Content-Type' => 'application/json' }, content
        end

        def json_halt_internal_error
          content_type :json
          json_halt 500, 500, 'Internal error'
        end

        def json_halt_not_found
          content_type :json
          json_halt 404, 404, 'not found'
        end
      end
    end
  end
end
