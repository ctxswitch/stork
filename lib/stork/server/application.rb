require 'sinatra'

module Stork
  module Server
    class Application < Sinatra::Base
      configure do
        enable :logging
        disable :show_exceptions
        mime_type :plain, 'text/plain'
        mime_type :json, 'application/json'
      end

      before do
        logger.datetime_format = '%Y/%m/%d @ %H:%M:%S '
        logger.level = Logger::INFO
      end

      get '/' do
        loginfo 'GET /'
        json_halt 200, 200, "Stork Version #{VERSION} - #{CODENAME}"
      end

      get '/api/v1/reload' do
        reload_collection
      end

      get '/api/v1/actions' do
        h = {'hosts' => database.hosts}
        json_halt_ok_with_content(h.to_json)
      end

      get '/api/v1/sync' do
        sync_collection
      end

      get '/api/v1/hosts' do
        h = {'hosts' => hosts.hashify}
        json_halt_ok_with_content(h.to_json)
      end

      get '/api/v1/host/:host' do |host|
        h = hosts.get(host)
        if h
          json_halt_ok_with_content(h.hashify.to_json)
        else
          json_halt_not_found
        end
      end

      get '/host/:host' do |host|
        loginfo "#{host} requested kickstart"

        h = hosts.get(host)

        if h && is_installable?(host)
          loginfo "Returned kickstart to #{host}"
          # hmm, should the host deploy?
          ks = Stork::Deploy::InstallScript.new(h) # we will be passing the type in shortly
          content_type :plain
          ks.render
        else
          logerr "Was not able to return kickstart"
          json_halt_not_found
        end
      end

      get '/host/:host/installed' do |host|
        loginfo "#{host} has notified completed install"
        h = hosts.get(host)

        if h
          set_localboot(h)
          json_halt_ok
        else
          json_halt_not_found
        end
      end

      get '/host/:host/install' do |host|
        loginfo "install requested for #{host}"
        h = hosts.get(host)

        if h
          set_install(h)
          json_halt_ok
        else
          json_halt_not_found
        end
      end

      get '/public/:filename' do |file|
        send_file public_path(file)
      end

      not_found do
        json_halt_not_found
      end

      error do
        json_halt_internal_error
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

        def database
          settings.database
        end

        def is_installable?(host)
          database.host(host)[:action] == 'install'
        end

        def reload_collection
          settings.collection = Stork::Builder.load.collection
          json_halt 200, 200, 'OK'
        end

        def sync_collection
          # make sure we reload the collection to pick up changes
          settings.collection = Stork::Builder.load.collection
          settings.database.sync_hosts(hosts)
          json_halt 200, 200, 'OK'
        end

        def set_localboot(host)
          database.boot_local(host.name)
          pxe(host).localboot
        end

        def set_install(host)
          database.boot_install(host.name)
          pxe(host).install
        end

        def pxe(host)
          Stork::PXE.new(host, host.stork, Configuration.port)
        end

        def public_path(filename)
          File.join(Configuration.public_path, filename)
        end

        def loginfo(msg)
          logger.info "[#{request.ip}] INFO: #{msg}"
        end

        def logerr(msg)
          logger.error "[#{request.ip}] ERROR: #{msg}"
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

        def json_halt_internal_error(content="Internal error")
          content_type :json
          json_halt 500, 500, content
        end

        def json_halt_not_found
          content_type :json
          json_halt 404, 404, 'Not found'
        end
      end
    end
  end
end
