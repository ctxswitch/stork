module Midwife
  class Kickstart
    def initialize(template, host, config=nil)
      @template = template
      @host = host
      @config = config
    end

    def render
      renderer = ERB.new(File.read(@template))
      renderer.result(KickstartBindings.new(self, @host).get_binding)
    end

    class KickstartBindings
      attr_reader :host

      def initialize(binder, host)
        @host = host
      end

      def get_binding
        binding
      end

      def pre_snippets
        lines = []
        lines << "%pre"
        host.pre_snippets.each do |snippet|
          lines << snippet.name
        end
        lines << "%end"
        lines.join("\n")
      end

      def post_snippets
        lines = []
        lines << "%post --log=/root/midwife-post.log"
        lines << "chvt 3"
        host.post_snippets.each do |snippet|
          lines << snippet.name
        end
        lines << "%end"
        lines.join("\n")
      end

      def url
        str = "url"
        str += " --url #{host.distro.url}"
        str
      end

      def network
        lines = []
        host.interfaces.each do |interface|
          str = "network --device=#{interface.device} --bootproto=#{interface.bootproto}"
          # Handle the static setup
          if interface.static?
            str += " --ip=#{interface.ip}"
            str += " --netmask=#{interface.netmask}" if interface.netmask
            str += " --gateway=#{interface.gateway}" if interface.gateway
            str += " --nameserver=#{interface.nameservers.join(',')}" unless interface.nameservers.empty?
          end
          # Others
          str += " --onboot=#{interface.onboot ? 'yes' : 'no'}"
          str += " --noipv4" if interface.noipv4
          str += " --noipv6" if interface.noipv6
          str += " --nodefroute" if interface.nodefroute
          str += " --nodns" if interface.nodns
          str += " --ethtool=\"#{ethtool}\"" if interface.ethtool
          str += " --mtu=#{mtu}" if interface.mtu
          lines << str
        end
        lines.join("\n")
      end

      def password
        str = "rootpw"
        unless host.password.locked?
          str += host.password.encrypted ? " --iscrypted" : " --plaintext"
          str += " " + host.password.to_s
        else
          str += " --lock"
        end
        str
      end

      def firewall
        fw = host.firewall
        str = "firewall"
        if fw.enabled
          str += " --enabled"
          str += " --ssh" if fw.ssh
          str += " --telnet" if fw.telnet
          str += " --smtp" if fw.smtp
          str += " --http" if fw.http
          str += " --ftp" if fw.ftp
          str += " --port #{fw.ports_allowed.join(',')}" unless fw.ports_allowed.empty?
          fw.trusted_devices.each do |device|
            str += " --trust #{device}"
          end
        else
          str += " --disabled"
        end
        str
      end

      def timezone
        tz = host.timezone
        str = "timezone"
        str += " --utc" if tz.utc
        str += " --nontp" if tz.nontp
        # str += " --ntpservers=#{tz.ntpservers.join(',')}" unless tz.ntpservers.empty?
        str += " #{tz.zone}"
        str
      end

      def selinux
        "selinux --#{host.selinux}"
      end

      def layout
        layout = host.layout
        lines = []
        lines << "zerombr" if layout.zerombr
        lines << "clearpart --all --initlabel" if layout.clearpart
        lines << partitions
        lines << volume_groups
        lines.join("\n")
      end

      def partitions
        # Emit partitions
        parts = host.layout.partitions
        lines = []
        parts.each do |part|
          str = "part #{part.path}"
          str += " --fstype #{part.type}" if part.type
          str += " --asprimary" if part.primary

          unless part.recommended
            str += " --size #{part.size}"
            str += " --grow" if part.grow
          else
            str += " --recommended"
          end
          lines << str
        end
        lines.join("\n")
      end

      def volume_groups
        # Emit volume groups
        vgs = host.layout.volume_groups
        lines = []
        vgs.each do |vg|
          lines << "volgroup #{vg.name} #{vg.partition}"
          vg.logical_volumes.each do |lv|
            str = "logvol #{lv.path} --vgname=#{vg.name} --name=#{lv.name}"
            str += " --fstype #{lv.type}" if lv.type
            unless lv.recommended
              str += " --size #{lv.size}"
              str += " --grow" if lv.grow
            else
              str += " --recommended"
            end
            lines << str
          end
        end
        lines.join("\n")
      end

      def packages
        host.packages.join("\n")
      end
    end
  end
end
