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
    class Schemes
      attr_reader 

      def initialize
        @schemes = {}
      end

      def find(name)
        @schemes[name]
      end

      def add_scheme(name, &block)
        @schemes[name] = Midwife::DSL::PartitionScheme.build(name, &block)
      end

      def self.build(&block)
        schemes = new
        # Get the partitions and schemes
        delegator = SchemesDelegator.new(schemes)
        unless block_given?
          Dir.glob("#{Midwife.configuration.path}/partition_schemes/*.rb").each do |filename|
            # name = File.basename(filename, '.rb')
            delegator.instance_eval(File.read(filename), filename)
          end
        else
          delegator.instance_eval(&block)
        end
        schemes
      end

      class SchemesDelegator < SimpleDelegator
        def scheme(name, &block)
          add_scheme(name, &block)
        end
      end
    end
  end
end