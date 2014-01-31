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
require "midwife/base"
require "delegate"
require "erb"

module Midwife
  include Base
  extend Base
  module DSL
    autoload :Builder,          'midwife/dsl/builder'
    autoload :Partition,        'midwife/dsl/partition'
    autoload :Partitions,       'midwife/dsl/partitions'
    autoload :NetworkInterface, 'midwife/dsl/network_interface'
    autoload :Domain,           'midwife/dsl/domain'
    autoload :Host,             'midwife/dsl/host'
  end

  # module Models
  #   autoload :Domain,           'midwife/models/domain'
  #   autoload :Host,             'midwife/models/host'
  #   autoload :NetworkInterface, 'midwife/models/network_interface'
  # end

  autoload :Config,           'midwife/config'
  autoload :NotFound,         'midwife/exceptions'
  autoload :PermissionDenied, 'midwife/exceptions'
end
