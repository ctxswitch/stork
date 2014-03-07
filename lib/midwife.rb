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

require 'delegate'
require 'erb'
require 'midwife/version'
require 'midwife/configuration'
require 'midwife/core'
require 'midwife/pxe'
require 'midwife/builder'
require 'midwife/build/options'
require 'midwife/build/base'
require 'midwife/build/partition'
require 'midwife/build/scheme'
require 'midwife/build/network_interface'
require 'midwife/build/domain'
require 'midwife/build/host'
require 'midwife/build/distro'
require 'midwife/build/chef'
require 'midwife/server/application'
require 'midwife/server/control'

module Midwife
  class NotFound < StandardError; end
  class PermissionDenied < StandardError; end
end
