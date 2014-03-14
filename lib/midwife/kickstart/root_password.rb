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
    class RootPassword < Command
      name 'rootpw'
      option 'iscrypted', boolean: true, default: true, unsets: 'plaintext'
      option 'plaintext', boolean: true, default: false, unsets: 'iscrypted'
      option 'lock', boolean: true, default: true

      # def crypt
      #   unless password
      #     password = random_password
      #   end
      #   salt = rand(36**8).to_s(36)
      #   password.crypt("$6$" + salt)
      # end

      def password
        value || random_password
      end

      def emit
        str = "rootpw"
        unless lock
          str += iscrypted ? " --iscrypted" : " --plaintext"
          str += " " + password
        else
          str += " --lock" 
        end
        str
      end

    # private
    #   def random_password
    #     SecureRandom.urlsafe_base64(40)
    #   end
    end
  end
end