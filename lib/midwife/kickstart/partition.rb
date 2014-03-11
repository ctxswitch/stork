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
    class Partition < Command
      name   'part'
      option 'size',        type: Integer
      option 'type',        as: :fstype, default: 'ext4'
      option 'primary',     boolean: true, default: false, as: 'asprimary'
      option 'grow',        boolean: true, default: false
      option 'recommended', boolean: true, default: true, not_if: 'size'
    end
  end
end