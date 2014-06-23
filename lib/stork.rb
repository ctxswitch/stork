require 'erb'
require 'json'
require 'securerandom'

require 'stork/version'
require 'stork/configuration'
require 'stork/collections'
require 'stork/resources'

require 'stork/builder'

require 'stork/deploy/command'
require 'stork/deploy/section'
require 'stork/deploy/snippet_binding'
require 'stork/deploy/kickstart_binding'
require 'stork/deploy/install_script'

require 'stork/pxe'
require 'stork/database'

require 'stork/server/application'
require 'stork/server/control'

require 'stork/plugin'
Dir[File.join('./lib/stork/client/plugins', '*.rb')].each do |plugin|
  require plugin
end

# Also make sure we allow a .stork/plugins dir
