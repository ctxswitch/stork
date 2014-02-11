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

require "midwife/version"
require "midwife/configuration"
require "midwife/core"
require "midwife/exceptions"
require "delegate"
require "erb"

module Midwife
  module DSL
    autoload :Builder,          'midwife/dsl/builder'
    autoload :Partition,        'midwife/dsl/partition'
    autoload :PartitionScheme,  'midwife/dsl/partition_scheme'
    autoload :Schemes,          'midwife/dsl/schemes'
    autoload :NetworkInterface, 'midwife/dsl/network_interface'
    autoload :Domains,          'midwife/dsl/domains'
    autoload :Domain,           'midwife/dsl/domain'
    autoload :Hosts,            'midwife/dsl/hosts'
    autoload :Host,             'midwife/dsl/host'
    autoload :Distros,          'midwife/dsl/distros'
    autoload :Distro,           'midwife/dsl/distro'
  end

  module Server
    autoload :Application,      'midwife/server/application'
    autoload :Control,          'midwife/server/control'
  end

  # module Models
  #   autoload :Domain,           'midwife/models/domain'
  #   autoload :Host,             'midwife/models/host'
  #   autoload :NetworkInterface, 'midwife/models/network_interface'
  # end

  # autoload :Config,           'midwife/config'
  # autoload :Builder,          'midwife/builder'
  # autoload :Commands,         'midwife/commands'
  autoload :PXE,              'midwife/pxe'
end
