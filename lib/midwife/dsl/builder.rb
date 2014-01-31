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
    class Builder
      def self.from_file(klass, filename)
        begin
          klass.new.tap do |obj|
            obj.instance_eval(File.read(filename), filename)
          end
        rescue Errno::ENOENT
          raise NotFound.new("#{klass.to_s} builder: #{filename} is not present.")
        end
      end

      def self.from_string(klass, content)
        klass.new.tap do |obj|
          obj.instance_eval(content)
        end
      end
    end
  end
end
