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
    class Host
      include Base
      allow_objects :distro, :scheme, :net, :chef
      string :template
      string :name
      string :pxemac
      string :timezone
      symbol :selinux
      string :password
      array :run_list
      chef :chef
      net :net, multi: true
      scheme :scheme
      distro :distro
    end
  end
end
