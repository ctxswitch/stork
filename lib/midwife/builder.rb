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

    def host(name, &block)
      @collection.hosts.add(
        Midwife::DSL::Host.build(collection, name, &block)
      )
    end

    def layout(name, &block)
      @collection.layouts.add(
        Midwife::DSL::Layout.build(name, &block)
      )
    end

    def network(name, &block)
      @collection.networks.add(
        Midwife::DSL::Network.build(name, &block)
      )
    end

    def chef(name, &block)
      @collection.chefs.add(
        Midwife::DSL::Chef.build(name, &block)
      )
    end

    def distro(name, &block)
      @collection.distros.add(
        Midwife::DSL::Distro.build(name, &block)
      )
    end

    def snippets
      Dir.glob(@configuration.snippets_path + "/*.erb") do |file|
        @collection.snippets.add(
          Midwife::DSL::Snippet.new(file)
        )
      end
    end
  end
end
