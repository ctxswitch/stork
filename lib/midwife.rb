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

require "delegate"
require "erb"
require "midwife/version"
require "midwife/configuration"
require "midwife/core"
require "midwife/exceptions"

module Midwife
  autoload :PXE,              'midwife/pxe'
  autoload :Builder,          'midwife/builder'
  
  module Build
    autoload :Partition,        'midwife/build/partition'
    autoload :Scheme,           'midwife/build/scheme'
    autoload :NetworkInterface, 'midwife/build/network_interface'
    autoload :Domain,           'midwife/build/domain'
    autoload :Host,             'midwife/build/host'
    autoload :Distro,           'midwife/build/distro'
  end

  module Server
    autoload :Application,      'midwife/server/application'
    autoload :Control,          'midwife/server/control'
  end
end
