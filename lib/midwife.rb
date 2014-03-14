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
require 'midwife/pxe'
require 'midwife/dsl/base'
require 'midwife/dsl/distro'
require 'midwife/dsl/chef'
require 'midwife/dsl/partition'
require 'midwife/dsl/scheme'
require 'midwife/dsl/domain'
require 'midwife/dsl/net'
require 'midwife/dsl/host'
require 'midwife/kickstart/builder'
require 'midwife/kickstart/option'
require 'midwife/kickstart/command'
require 'midwife/kickstart/partition'
require 'midwife/kickstart/network'
require 'midwife/kickstart/bootloader'
require 'midwife/kickstart/zerombr'
require 'midwife/kickstart/clearpart'
require 'midwife/kickstart/firewall'
require 'midwife/kickstart/root_password'
require 'midwife/kickstart/selinux'
require 'midwife/kickstart/timezone'
require 'midwife/kickstart/url'

module Midwife
  class NotFound < StandardError; end
  class PermissionDenied < StandardError; end
  class FileNotFound < StandardError; end
end
