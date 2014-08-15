require 'mixlib/config'

module Stork
  class Configuration
    extend Mixlib::Config
    config_strict_mode true

    default :path, '/etc/stork'
    default :bundle_path, '/etc/stork/bundles'
    default :authorized_keys_file, '/etc/stork/authorized_keys'
    default :pxe_path, '/var/lib/tftpboot/pxelinux.cfg'
    default :log_file, '/var/log/stork.log'
    default :pid_file, '/var/run/stork.pid'
    default :timezone, 'America/Los_Angeles'

    default :server, 'localhost'
    default :port, 9293
    default :bind, '0.0.0.0'
    
    def self.relative_to_bundle_path(path)
      File.join(self.configuration[:bundle_path], path)
    end

    default(:hosts_path) { relative_to_bundle_path('hosts') }
    default(:snippets_path) { relative_to_bundle_path('snippets') }
    default(:layouts_path) { relative_to_bundle_path('layouts') }
    default(:networks_path) { relative_to_bundle_path('networks') }
    default(:templates_path) { relative_to_bundle_path('templates') }
    default(:chefs_path) { relative_to_bundle_path('chefs') }
    default(:distros_path) { relative_to_bundle_path('distros') }
    default(:public_path) { relative_to_bundle_path('public') }

    default(:client_name) { 'root' }
    default(:client_key) { '~/.stork/root.pem' }
    default(:stork_server_url) { "http://#{self.configuration[:server]}:#{self.configuration[:port]}" } 

    # Only used for the server.  Clients will use a plugin to
    # interactively set the parameters or create it manually.
    def self.to_file(config_path)
      content = <<-EOS.gsub(/^ {8}/, '')
        # Stork configuration file
        path                    "#{path}"
        bundle_path             "#{bundle_path}"
        authorized_keys_file    "#{authorized_keys_file}"
        pxe_path                "#{pxe_path}"
        log_file                "#{log_file}"
        pid_file                "#{pid_file}"
        server                  "#{server}"
        port                    #{port}
        bind                    "#{bind}"
        timezone                "#{timezone}"
      EOS
      File.open(config_path,'w') { |f| f.write(content) }
    end
  end
end
