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
  class Builder
    attr_reader :collection

    def initialize(configuration)
      @configuration = configuration
      @collection = Midwife::Collection.new
    end

    def self.load(configuration)
      builder = Builder.new(configuration)
      delegator = BuilderDelegator.new(builder)
      delegator.snippets(configuration.snippets_path)
      delegator.templates(configuration.templates_path)
      puts configuration.chefs_path
      [ configuration.distros_path,
        configuration.chefs_path,
        configuration.networks_path,
        configuration.layouts_path,
        configuration.hosts_path ].each do |path|
        Dir.glob(path + "/*.rb") do |file|
          delegator.instance_eval(File.read(file))
        end
      end
      builder
    end

    class BuilderDelegator
      def initialize(obj)
        @delegated = obj
      end

      def host(name, &block)
        @delegated.collection.hosts.add(
          Midwife::DSL::Host.build(@delegated.collection, name, &block)
        )
      end

      def layout(name, &block)
        @delegated.collection.layouts.add(
          Midwife::DSL::Layout.build(name, &block)
        )
      end

      def network(name, &block)
        @delegated.collection.networks.add(
          Midwife::DSL::Network.build(name, &block)
        )
      end

      def chef(name, &block)
        @delegated.collection.chefs.add(
          Midwife::DSL::Chef.build(name, &block)
        )
      end

      def distro(name, &block)
        @delegated.collection.distros.add(
          Midwife::DSL::Distro.build(name, &block)
        )
      end

      def templates(path)
        Dir.glob(path + "/*.erb") do |file|
          @delegated.collection.templates.add(
            Midwife::DSL::Template.new(file)
          )
        end
      end

      def snippets(path)
        Dir.glob(path + "/*.erb") do |file|
          @delegated.collection.snippets.add(
            Midwife::DSL::Snippet.new(file)
          )
        end
      end
    end
  end
end
