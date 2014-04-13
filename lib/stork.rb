require 'erb'
require 'json'
require 'securerandom'

require 'stork/version'
require 'stork/configuration'
require 'stork/collections'

require 'stork/objects/chef'
require 'stork/objects/distro'
require 'stork/objects/partition'
require 'stork/objects/logical_volume'
require 'stork/objects/volume_group'
require 'stork/objects/layout'
require 'stork/objects/network'
require 'stork/objects/interface'
require 'stork/objects/firewall'
require 'stork/objects/password'
require 'stork/objects/timezone'
require 'stork/objects/snippet'
require 'stork/objects/template'
require 'stork/objects/repo'
require 'stork/objects/host'

require 'stork/builder'

require 'stork/deploy/bindings/snippet'
require 'stork/deploy/bindings/kickstart'
require 'stork/deploy/kickstart'

require 'stork/pxe'

require 'stork/server/application'
require 'stork/server/control'

module Stork
end
