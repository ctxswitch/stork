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
  module DSL
    class Domains
      def initialize
        @domains = {}
      end

      def find(name)
        @domains[name]
      end

      def add_domain(name, &block)
        @domains[name] = Midwife::DSL::Domain.build(name, &block)
      end

      def self.build(&block)
        domains = new
        # Get the partitions and domains
        delegator = DomainsDelegator.new(domains)
        unless block_given?
          Dir.glob("#{Midwife.configuration.path}/domains/*.rb").each do |filename|
            delegator.instance_eval(File.read(filename), filename)
          end
        else
          delegator.instance_eval(&block)
        end
        domains
      end

      class DomainsDelegator < SimpleDelegator
        def domain(name, &block)
          add_domain(name, &block)
        end
      end
    end
  end
end
