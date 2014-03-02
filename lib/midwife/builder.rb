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
  # The +Builder+ class reads in all configurations and creates hosts.
  class Builder
    include Core

    attr_reader :hosts, :schemes, :distros, :domains, :templates, :chefs

    def initialize
      @hosts = {}
      @schemes = {}
      @distros = {}
      @domains = {}
      @templates = {}
      @chefs = {}
    end

    # Convert a class to its lowercase name and use that to 
    # access the attribute using the name as the key
    def find(klass, name)
      send(:"#{klass.to_s.split("::").last.downcase}s")[name]
    end

    # Add a +Domain+ 
    def add_domain(name, &block)
      @domains[name] = Midwife::Build::Domain.build(name, &block)
    end

    # Add a +Host+
    def add_host(name, &block)
      @hosts[name] = Midwife::Build::Host.build(name, &block)
    end

    # Add a partition +Scheme+
    def add_scheme(name, &block)
      @schemes[name] = Midwife::Build::Scheme.build(name, &block)
    end

    # Add a +Distro+
    def add_distro(name, &block)
      @distros[name] = Midwife::Build::Distro.build(name, &block)
    end

    # Add a custom kickstart +Template+
    def add_template(name, content)
      @templates[name] = content
    end

    # Add chef definition (+Chef+)
    def add_chef(name, &block)
      @chefs[name] = Midwife::Build::Chef.build(name, &block)
    end

    def self.build
      builder = new
      # Pretty shitty way to stop the recursion hell and stack overflow
      export builder

      delegator = BuilderDelegator.new(builder)

      # Pick up the templates
      Dir.glob("#{Midwife.configuration.path}/templates/*.erb").inject({}) do |tmpls, filename|
        name = File.basename(filename, '.erb')
        builder.add_template(name, File.read(filename))
      end

      # Try for the deploy file first
      filename = "#{Midwife.configuration.path}/deploy.rb"
      delegator.instance_eval(File.read(filename), filename)

      # Next go for the host files
      Dir.glob("#{Midwife.configuration.path}/hosts/*.rb").each do |filename|
        delegator.instance_eval(File.read(filename), filename)
      end

      builder
    end

    class BuilderDelegator < SimpleDelegator
      def domain(name, &block)
        add_domain(name, &block)
      end

      def host(name, &block)
        add_host(name, &block)
      end

      def scheme(name, &block)
        add_scheme(name, &block)
      end

      def distro(name, &block)
        add_distro(name, &block)
      end

      def chef(name, &block)
        add_chef(name, &block)
      end
    end
  end
end
