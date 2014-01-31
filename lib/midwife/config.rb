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
  class Config
    attr_reader :partitions, :domains, :templates, :hosts, :midwife

    def initialize
      @partitions = {}
      @templates = {}
      @domains = {}
      @distros = {}
      @hosts = {}
      @midwife = "localhost"
      # Expose
      Midwife.set_config(self)
    end

    def add_partitions(name, &block)
      @partitions[name] = Midwife::DSL::Partitions.new(name).tap do |p|
        p.instance_eval(&block)
      end
    end

    def add_domain(name, &block)
      @domains[name] = Midwife::DSL::Domain.new(name).tap do |d|
        d.instance_eval(&block)
      end
    end

    def add_template(name, content)
      @templates[name] = content
    end

    def add_host(name, &block)
      @hosts[name] = Midwife::DSL::Host.build(name, &block)
    end

    def self.build(path)
      config = new
      # Get the partitions and domains
      delegator = ConfigDelegator.new(config)
      %w{ domains partitions }.each do |f|
        filename = "#{path}/#{f}.rb"
        delegator.instance_eval(File.read(filename), filename)
      end

      # Read in the templates
      Dir.glob("#{path}/templates/*.erb").each do |filename|
        name = File.basename(filename, '.erb')
        config.add_template(name, File.read(filename))
      end
      
      # Read in the hosts
      Dir.glob("#{path}/hosts/*.rb").each do |filename|
        name = File.basename(filename, '.rb')
        delegator.instance_eval(File.read(filename), filename)
      end
      config
    end

    class ConfigDelegator < SimpleDelegator
      def domain(name, &block)
        add_domain(name, &block)
      end

      def partitions(name, &block)
        add_partitions(name, &block)
      end

      def host(name, &block)
        add_host(name, &block)
      end
    end
  end
end