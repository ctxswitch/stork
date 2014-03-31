# Copyright 2012, Rob Lyon
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "sinatra"

module Midwife
  module Server
    class Application < Sinatra::Base
      configure do
        enable :logging
        mime_type :plain, 'text/plain'
        mime_type :json, 'application/json'
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

        h = hosts.get(host)

        if h
          ks = Midwife::Kickstart.new(h, midwife)
          content_type :plain
          ks.render
        else
          json_halt_not_found
        end
      end

      get '/notify/:host/installed' do |host|
        info "#{host} has notified completed install"
        h = hosts.get(host)

        if h
          set_localboot(h)
          json_halt_ok
        else
          json_halt_not_found
        end
      end

      get '/notify/:host/install' do |host|
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
          @hosts ||= settings.collection.hosts
        end

        def midwife
          @midwife ||= settings.midwife
        end

        def set_localboot(host)
          pxe = Midwife::PXE.new(
            midwife.server,
            midwife.pxe_path,
            host.name,
            host.pxemac,
            host.distro.kernel,
            host.distro.image
          )
          pxe.localboot
        end

        def set_install(host)
          pxe = Midwife::PXE.new(
            midwife.server,
            midwife.pxe_path,
            host.name,
            host.pxemac,
            host.distro.kernel,
            host.distro.image
          )
          pxe.install
        end

        def info(msg)
          logger.info "[#{request.ip}] INFO: #{msg}"
        end

        def json_halt(request_status, op_status, message)
          content_type :json
          halt request_status, {'Content-Type' => 'application/json'}, "{ \"status\":\"#{op_status}\", \"message\": \"#{message}\" }"
        end

        def json_halt_ok
          content_type :json
          json_halt 200, 200, "OK"
        end

        # def json_halt_internal_error
        #   content_type :json
        #   json_halt 500, 500, "Internal error"
        # end

        def json_halt_not_found
          content_type :json
          json_halt 404, 404, "not found"
        end

        # def json_halt_parse_error
        #   content_type :json
        #   json_halt 404, 404, "There was a problem parsing the configuration file"
        # end
      end
    end
  end
end
