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
      def self.start(configuration, collection)
        puts "Starting midwife server on port #{configuration.port}."
        app = Midwife::Server::Application
        app.set :collection, collection
        app.set :midwife, configuration

        @thin = Thin::Server.new(configuration.bind, configuration.port, app)
        @thin.tag = "Midwife #{VERSION}"
        unless ENV['RACK_ENV'] == "test"
          @thin.pid_file = configuration.pid_file
          @thin.log_file = configuration.log_file
          @thin.daemonize
        else
          puts "Running in test mode"
        end
        @thin.start
      end

      def self.stop(configuration, collection)
        puts "Stoping the midwife server."
        Thin::Server.kill(configuration.pid_file)
      end

      def self.restart(configuration, collection)
        stop(configuration, collection)
        start(configuration, collection)
      end
    end
  end
end
