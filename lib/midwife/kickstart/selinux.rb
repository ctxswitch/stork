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
    class Selinux < Command
      name 'selinux'
      option 'disabled', boolean: true, default: true, unsets: %w{enforcing permissive}
      option 'enforcing', boolean: true, default: false, unsets: %w{disabled permissive}
      option 'permissive', boolean: true, default: false, unsets: %w{disabled enforcing}
    end
  end
end