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
  module Kickstart
    class Firewall < Command
      name 'firewall'
      option 'enabled', boolean: true, default: true, unsets: 'disabled'
      option 'disabled', boolean: true, default: false, unsets: 'enabled'
      option 'ssh', boolean: true, default: true
      option 'smtp', boolean: true, default: false
      option 'http', boolean: true, default: false
      option 'ftp', boolean: true, default: false

      def emit
        str = "firewall"
        if enabled
          str += " --enabled"
          str += " --ssh" if ssh
          str += " --smtp" if smtp
          str += " --http" if http
          str += " --ftp" if ftp
        else
          str += " --disabled"
        end
        str += " #{value}" unless value.empty?
        str
      end
    end
  end
end