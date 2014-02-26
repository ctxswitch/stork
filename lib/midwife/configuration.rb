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

module Midwife
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :path, :server, :pxe_path, :authorized_keys, :ntp_server, :log_file
    attr_accessor :pid_file

    def initialize
      @path = "/etc/midwife"
      @server = "localhost"
      @pxe_path = "tmp/tftpboot/pxelinux.cfg"
      @log_file = "tmp/log/midwife.log"
      @pid_file = "tmp/run/midwife.pid"
      @authorized_keys = ""
      @ntp_server = "pool.ntp.org"
    end

    def from_file(filename)
      delegator = ConfigDelegator.new(self)
      delegator.instance_eval(File.read(filename), filename)
    end

    class ConfigDelegator < SimpleDelegator
      def initialize(obj)
        super
        @delegated = obj
      end

      def authorized_keys(pubfile)
        @delegated.authorized_keys = File.read(pubfile)
      end

      def method_missing(meth, *args)
        @delegated.send("#{meth.to_s}=", *args)
      end
    end
  end
end