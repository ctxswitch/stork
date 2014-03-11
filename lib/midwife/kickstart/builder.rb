module Midwife
  module Kickstart
    class Builder
      attr_reader :template, :host, :domain, :scheme, :chef, :post

      def initialize(template, args = {})
        @template = template
        # Should pick up defaults from configurations
        @host = args.has_key?(:host) ? args[:host] : nil
        @domain = args.has_key?(:domain) ? args[:domain] : nil
        @scheme = args.has_key?(:scheme) ? args[:scheme] : nil
        @chef = args.has_key?(:chef) ? args[:chef] : nil
        @post = args.has_key?(:post) ? args[:post] : nil
      end

      def render
        unless @template
          template = File.dirname(__FILE__) + '/../erbs/kickstart.erb'
          renderer = ERB.new(File.read(template))
        else
          renderer = ERB.new(@template)
        end
        renderer.result(BuilderBindings.new(self).get_binding())
      end

      class BuilderBindings
        attr_reader :host, :domain, :scheme, :chef, :post
        def initialize(obj)
          @host = @obj.host
          @domain = @obj.domain
          @scheme = @obj.scheme
          @chef = @obj.chef
          @post = @obj.post
        end

        def get_binding
          binding
        end

        def partitions
          # return partitions
        end

        def interfaces
          # return network interfaces
        end

        def bootstrap
          # return chef bootstrap script
        end

        def hostname
          # return hostname
        end

        def packages
          strs = %w{
            @core
            curl
            openssh-clients
            openssh-server
            finger
            pciutils
            yum
            at
            acpid
            vixie-cron
            cronie-noanacron
            crontabs
            logrotate
            ntp
            ntpdate
            tmpwatch
            rsync
            mailx
            which
            wget
            man
          }
          strs.join("\n")
        end
      end
    end
  end
end

