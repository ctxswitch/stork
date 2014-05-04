require 'erb'
require 'json'
require 'securerandom'

require 'stork/version'
require 'stork/configuration'
require 'stork/collections'
require 'stork/resources'

require 'stork/builder'

# require 'stork/deploy/bindings/snippet'
# require 'stork/deploy/bindings/kickstart'

require 'stork/deploy/commands/command'
require 'stork/deploy/commands/section'
require 'stork/deploy/commands/snippet'
require 'stork/deploy/commands/kickstart'
require 'stork/deploy/install_script'

require 'stork/pxe'

require 'stork/server/application'
require 'stork/server/control'
