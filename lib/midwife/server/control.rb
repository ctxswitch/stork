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

require 'sinatra'
require 'json'
require 'rack'
require 'thin'

module Midwife
  module Server
    class Control
      class << self
        def start
          puts "Starting midwife server on port 9293."
          @thin = Thin::Server.new("0.0.0.0", 9293, Midwife::Server::Application)
          @thin.tag = "Midwife #{VERSION}"
          unless ENV['RACK_ENV'] == "test"
            @thin.pid_file = Midwife.configuration.pid_file
            @thin.log_file = Midwife.configuration.log_file
            @thin.daemonize
          else
            puts "Running in test mode"
          end
          @thin.start
        end

        def stop
          puts "Stoping the midwife server."
          pid_file = Midwife.configuration.pid_file
          Thin::Server.kill(pid_file)
        end

        def restart
          stop
          start
        end
      end
    end
  end
end