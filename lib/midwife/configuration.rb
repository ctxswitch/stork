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
  class Configuration
    attr_accessor :etc
    attr_accessor :hosts_path
    attr_accessor :snippets_path
    attr_accessor :layouts_path
    attr_accessor :networks_path
    attr_accessor :distros_path
    attr_accessor :templates_path
    attr_accessor :chefs_path
    attr_accessor :authorized_keys_file
    attr_accessor :var
    attr_accessor :pxe_path
    attr_accessor :log_file
    attr_accessor :tmp
    attr_accessor :pid_file
    attr_accessor :server
    attr_accessor :port
    attr_accessor :bind
    attr_accessor :timezone

    def initialize
      @etc = "/etc/midwife"
      @hosts_path = etc + "/hosts"
      @snippets_path = etc + "/snippets"
      @layouts_path = etc + "/layouts"
      @networks_path = etc + "/networks"
      @authorized_keys_file = etc + "/keys/authorized_keys"
      @distros_path = etc + "/distros"
      @templates_path = etc + "/templates"
      @chefs_path = etc + "/chefs"

      @var = "/var"
      @pxe_path = var + "/lib/tftpboot/pxelinux.cfg"
      @log_file = var + "/log/midwife.log"

      @tmp = "/tmp"
      @pid_file = tmp + "/midwife.pid"

      @server = "localhost"
      @port = 4000
      @bind = "0.0.0.0"
      @timezone = "America/Los_Angeles"
    end

    def self.from_file(filename)
      config = new
      delegator = ConfigDelegator.new(config)
      delegator.instance_eval(File.read(filename), filename)
      config
    end

    class ConfigDelegator
      def initialize(obj)
        @delegated = obj
      end

      def method_missing(meth, *args)
        @delegated.send("#{meth.to_s}=", *args)
      end
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
