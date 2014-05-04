module Stork
  module Deploy
    module Commands
      class Kickstart
        attr_reader :host, :configuration

        def initialize(host)
          @host = host
          @configuration = host.configuration
        end

        def url
          Command.create 'url' do |c|
            c.option 'url', host.distro.url
          end
        end

        def network
          commands = []
          host.interfaces.each do |interface|
            command = Command.create 'network' do |c|
              c.option 'device', interface.device
              c.option 'bootproto', interface.bootproto
              if interface.static?
                c.option 'ip', interface.ip
                c.option 'netmask', interface.netmask
                c.option 'gateway', interface.gateway
                c.option 'nameserver', interface.nameservers
              end
              c.yes_no 'onboot', interface.onboot
              c.boolean 'noipv4', !interface.ipv4
              c.boolean 'noipv6', !interface.ipv6
              c.boolean 'nodefroute', !interface.defroute
              c.boolean 'nodns', !interface.dns
              c.option 'ethtool', interface.ethtool
              c.option 'mtu', interface.mtu
            end
            commands << command
          end
          commands.join("\n")
        end

        def password
          Command.create 'rootpw' do |c|
            c.value host.password.value

            if host.password.locked?
              c.boolean 'lock', true
            else
              c.either_or 'iscrypted', 'plaintext', host.password.encrypted
            end
          end
        end

        def firewall
          fw = host.firewall
          Command.create 'firewall' do |c|
            c.either_or 'enabled', 'disabled', fw.enabled
            if fw.enabled
              c.boolean 'ssh', fw.ssh
              c.boolean 'telnet', fw.telnet
              c.boolean 'smtp', fw.smtp
              c.boolean 'http', fw.http
              c.boolean 'ftp', fw.ftp
              c.option 'port', fw.allowed_ports
              c.multi 'trust', fw.trusted_devices
            end
          end
        end

        def timezone
          tz = host.timezone
          Command.create 'timezone' do |c|
            c.value tz.zone
            # c.boolean 'utc', tz.utc
            # c.boolean 'ntp', tz.ntp
            # c.option 'ntpservers', tz.ntpservers
          end
        end

        def selinux
          Command.create 'selinux' do |c|
            c.boolean host.selinux, true
          end
        end

        def layout
          commands = []
          commands << bootloader
          commands << zerombr
          commands << clearpart
          commands << partitions
          commands << volume_groups
          commands.join("\n")
        end

        def bootloader
          Command.create 'bootloader' do |c|
            c.option 'location', 'mbr'
          end
        end

        def zerombr
          Command.create 'zerombr' if host.layout.zerombr
        end

        def clearpart
          Command.create 'clearpart' do |c|
            c.boolean 'all', true
            c.boolean 'initlabel', true
          end if host.layout.clearpart
        end

        def partitions
          commands = []
          host.layout.partitions.each do |part|
            command = Command.create 'part' do |c|
              c.value part.path
              c.option 'fstype', part.type
              c.boolean 'asprimary', part.primary
              if part.recommended
                c.boolean 'recommended', true
              else
                c.option 'size', part.size
                c.boolean 'grow', part.grow
              end
            end
            commands << command
          end
          commands.join("\n")
        end

        def repos
          commands = []
          host.repos.each do |repo|
            command = Command.create 'repo' do |c|
              c.option 'name', repo.name
              c.option 'baseurl', repo.baseurl
              c.option 'mirrorlist', repo.mirrorlist
            end
            commands << command
          end
          commands.join("\n")
        end

        def volume_groups
          commands = []
          host.layout.volume_groups.each do |vg|
            command = Command.create 'volgroup' do |c|
              c.value "#{vg.name} #{vg.partition}"
            end
            commands << command
            commands << logical_volumes(vg)
          end
          commands.join("\n")
        end

        def logical_volumes(volume_group)
          commands = []
          volume_group.logical_volumes.each do |lv|
            command = Command.create 'logvol' do |c|
              c.value lv.path
              c.option 'vgname', lv.name
              c.option 'name', lv.name
              c.option 'fstype', lv.type
              if lv.recommended
                c.boolean 'recommended', true
              else
                c.option 'size', lv.size
                c.boolean 'grow', lv.grow
              end
            end
            commands << command
          end
          commands.join("\n")
        end

        def packages
          Section.create 'packages' do |s|
            s.content host.packages.join("\n")
          end
        end

        def pre_snippets
          Section.create 'pre' do |s|
            s.content render_snippets(host.pre_snippets)
          end
        end

        def post_snippets
          Section.create 'post', log: '/root/midwife-post.log' do |s|
            s.content render_snippets(host.post_snippets)
          end
        end

      private
        def render_snippets(snippets)
          lines = []
          snippets.each do |snippet|
            # Render me!!!
            renderer = ERB.new(snippet.content, nil, '-')
            lines << renderer.result(
              Snippet.new(@configuration, host).get_binding)
          end
          lines.join("\n")
        end
      end
    end
  end
end