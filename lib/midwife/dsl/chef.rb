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
    class Chef
      include Base
      # The chef version that will be installed on the client
      string :version
      # The url for the chef server (not the install).  i.e.
      # https://chef.example.com:4000
      string :url
      # The chef client name.  Not the name of the server, this is a
      # small hack to set up knife to do a reregister.  Mostly laziness
      # on my part when dealing with my cluster.  It should be an admin
      # client.
      string :client_name
      # The pem file for the client
      file :client_key
      # Validator name
      string :validator_name
      # Validation pem file
      file :validation_key
      # Your secret for encrypted databags
      string :encrypted_data_bag_secret
    end
  end
end
