module Midwife
  class Kickstart
    def initialize(host, configuration=nil)
      @template = host.template
      @host = host
      @configuration = configuration
    end

    def render
      renderer = ERB.new(@template.content)
      renderer.result(KickstartBindings.new(@configuration, @host).get_binding)
    end

    class KickstartBindings
      attr_reader :host

      def initialize(configuration, host)
        @host = host
        @configuration = configuration
      end

      def get_binding
        binding
      end

      def pre_snippets
        render_snippets(host.pre_snippets)
      end

      def post_snippets
        render_snippets(host.post_snippets)
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
        lines << "bootloader --location mbr"
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

      def repos
        lines = []
        host.repos.each do |repo|
          str = "repo --name=#{repo.name}"
          str += " --baseurl=#{repo.baseurl}" if repo.baseurl
          str += " --mirrorlist=#{repo.mirrorlist}" if repo.mirrorlist
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

    private
      def render_snippets(snippets)
        lines = []
        lines << "%pre"
        snippets.each do |snippet|
          # Render me!!!
          renderer = ERB.new(snippet.content, nil, '-')
          lines << renderer.result(SnippetBindings.new(@configuration, host).get_binding)
        end
        lines << "%end"
        lines.join("\n")
      end
    end

    class SnippetBindings
      attr_reader :host

      def initialize(configuration, host)
        @host = host
        @configuration = configuration
      end

      def get_binding
        binding
      end

      def chef
        host.chef
      end

      def authorized_keys
        File.read(@configuration.authorized_keys_file)
      end

      def first_boot_content
        run_list = {'run_list' => host.run_list }
        run_list.to_json
      end

      def nameservers
        host.interfaces.collect{ |x| x.nameservers }.uniq.flatten
      end

      def search_paths
        host.interfaces.collect{ |x| x.search_paths }.uniq.flatten
      end

      def midwife_server
        @configuration.server
      end

      def midwife_port
        @configuration.port
      end

      def midwife_bind
        @configuration.bind
      end
    end
  end
end
