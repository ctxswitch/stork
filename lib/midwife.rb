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

require 'erb'
require 'json'
require 'securerandom'

require 'midwife/version'
require 'midwife/configuration'

require 'midwife/collections/base'
require 'midwife/collections/chef'
require 'midwife/collections/distro'
require 'midwife/collections/host'
require 'midwife/collections/layout'
require 'midwife/collections/network'
require 'midwife/collections/snippet'

require 'midwife/collection'

require 'midwife/dsl/chef'
require 'midwife/dsl/distro'
require 'midwife/dsl/partition'
require 'midwife/dsl/logical_volume'
require 'midwife/dsl/volume_group'
require 'midwife/dsl/layout'
require 'midwife/dsl/network'
require 'midwife/dsl/interface'
require 'midwife/dsl/firewall'
require 'midwife/dsl/password'
require 'midwife/dsl/timezone'
require 'midwife/dsl/snippet'
require 'midwife/dsl/host'

require 'midwife/kickstart'
require 'midwife/builder'
require 'midwife/pxe'

# require 'midwife/pxe'
# require 'midwife/dsl'
# require 'midwife/kickstart/builder'
# require 'midwife/kickstart/option'
# require 'midwife/kickstart/command'
# require 'midwife/kickstart/partition'
# require 'midwife/kickstart/network'
# require 'midwife/kickstart/bootloader'
# require 'midwife/kickstart/zerombr'
# require 'midwife/kickstart/clearpart'
# require 'midwife/kickstart/firewall'
# require 'midwife/kickstart/root_password'
# require 'midwife/kickstart/selinux'
# require 'midwife/kickstart/timezone'
# require 'midwife/kickstart/url'

module Midwife
  # class NotFound < StandardError; end
  # class PermissionDenied < StandardError; end
  # class FileNotFound < StandardError; end
end
