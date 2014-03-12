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
        renderer.result(BuilderBindings.new(self).get_binding)
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

        def render_snippet(name)
          template = File.dirname(__FILE__) + "/erbs/#{name}.erb"
          renderer = ERB.new(File.read(template))
          renderer.result(get_binding)
        end

        def method_missing(sym, *args)
          # detect the snippets
          name = sym.to_s
          if name ~= /^snippet_.*$/

          else
            raise NoMethodError, "undefined method `#{sym}' when building kickstart"
          end
        end

        def get_binding
          binding
        end

        def partitions
          ""
        end

        def interfaces
          ""
        end

        def bootstrap
          ""
        end

        def hostname
          host.name || localhost
        end

        def ntpserver
          ""
        end

        def authorized_keys
          ""
        end

        def first_boot_content
          ""
        end

        def client_key
          ""
        end

        def knife_content
          ""
        end

        def client_content
          ""
        end

        def validation_key
          ""
        end

        def encrypted_data_bag_secret
          ""
        end

        def version
          ""
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

