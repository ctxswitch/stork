module Stork
  module Deploy
    class KickstartBinding
      attr_reader :host

      def initialize(host)
        @host = host
      end

      def url
        Command.create 'url' do |c|
          c.option 'url', host.distro.url
        end
      end

      def network
        commands = []
        host.interfaces.each do |i|
          commands << interface(i)
        end
        commands.join
      end

      def interface(interface)
        Command.create 'network' do |c|
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
        commands.join
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
        commands.join
      end

      def volume_groups
        commands = []
        host.layout.volume_groups.each do |vg|
          a = volume_group(vg)
          commands << a
          commands << logical_volumes(vg)
        end
        commands.join
      end

      def volume_group(vg)
        Command.create 'volgroup' do |c|
          c.value "#{vg.name} #{vg.partition}"
        end
      end

      def logical_volumes(volume_group)
        commands = []
        volume_group.logical_volumes.each do |lv|
          commands << logical_volume(volume_group, lv)
        end
        commands.join
      end

      def logical_volume(vg, lv)
        Command.create 'logvol' do |c|
          c.value lv.path
          c.option 'vgname', vg.name
          c.option 'name', lv.name
          filesystem_options(lv, c)
        end
      end

      def partitions
        commands = []
        host.layout.partitions.each do |part|
          commands << partition(part)
        end
        commands.join
      end

      def partition(part)
        Command.create 'part' do |c|
          c.value part.path
          c.boolean 'asprimary', part.primary
          filesystem_options(part, c)
        end
      end

      def filesystem_options(part_or_lv, command)
        command.option 'fstype', part_or_lv.type
        if part_or_lv.recommended
          command.boolean 'recommended', true
        else
          command.option 'size', part_or_lv.size
          command.boolean 'grow', part_or_lv.grow
        end
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
            Stork::Deploy::SnippetBinding.new(host).get_binding
          )
        end
        lines.join("\n")
      end
    end
  end
end
