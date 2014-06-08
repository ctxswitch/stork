module Stork
  module Resource
    class Host < Base
      attr_accessor :layout
      attr_accessor :template
      attr_accessor :chef
      attr_accessor :pxemac
      attr_accessor :pre_snippets
      attr_accessor :post_snippets
      attr_accessor :interfaces
      attr_accessor :distro
      attr_accessor :timezone
      attr_accessor :firewall
      attr_accessor :password
      attr_accessor :selinux
      attr_accessor :packages
      attr_accessor :run_list
      attr_accessor :repos
      attr_accessor :stork

      def setup
        @layout = nil
        @template = nil
        @distro = nil

        @chef = nil
        @pxemac = nil
        @selinux = 'enforcing'
        @stork = configuration ? configuration.server : 'localhost'
        
        @pre_snippets = Array.new
        @post_snippets = Array.new
        @interfaces = Array.new
        @run_list = Array.new
        @repos = Array.new
        @packages = default_packages
        
        @timezone = Timezone.new("America/Los_Angeles")
        @firewall = Firewall.new # get from config
        @password = Password.new
      end

      def hashify
        {
          'name'          => name,
          'distro'        => distro ? distro.name : '',
          'template'      => template ? template.name : '',
          'chef'          => chef ? chef.name : '',
          'layout'        => layout.hashify,
          'interfaces'    => interfaces.map{|i| i.hashify},
          'pre_snippets'  => pre_snippets.map{|s| s.name},
          'post_snippets' => post_snippets.map{|s| s.name},
          'repos'         => repos.map{|r| r.name},
          'run_list'      => run_list,
          'packages'      => packages,
          'timezone'      => timezone.zone,
          'selinux'       => selinux
        }
      end

      def validate!
        require_value(:layout)
        require_value(:template)
        require_value(:distro)
        require_value(:layout)
        require_value(:layout)
      end

      def default_packages
        %w(
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
        )
      end

      def deploy
        Stork::Deploy::Kickstart.new(self, configuration)
      end

      class HostDelegator < Stork::Resource::Delegator
        def layout(value, &block)
          if block_given?
            delegated.layout = Layout.build(value, &block)
          else
            delegated.layout = collection.layouts.get(value)
          end
        end

        def template(value)
          template = collection.templates.get(value)
          unless template
            fail SyntaxError, "The #{value} template was not found"
          end
          delegated.template = template
        end

        def chef(value, &block)
          if block_given?
            delegated.chef = Chef.build(value, &block)
          else
            delegated.chef = collection.chefs.get(value)
          end
        end

        def pxemac(value)
          delegated.pxemac = value
        end

        def stork(value)
          delegated.stork = value
        end

        def pre_snippet(value)
          snippet = collection.snippets.get(value)
          unless snippet
            fail SyntaxError, "The #{value} snippet was not found"
          end
          delegated.pre_snippets << snippet
        end

        def post_snippet(value)
          snippet = collection.snippets.get(value)
          unless snippet
            fail SyntaxError, "The #{value} snippet was not found"
          end
          delegated.post_snippets << snippet
        end

        def interface(value, &block)
          delegated.interfaces << Interface.build(value, collection: collection, &block)
        end

        def distro(value, &block)
          if block_given?
            delegated.distro = Distro.build(value, &block)
          else
            delegated.distro = collection.distros.get(value)
          end
        end

        def firewall(&block)
          unless block_given?
            fail SyntaxError, 'Firewall requires a block'
          end
          delegated.firewall = Firewall.build(&block)
        end

        def password(&block)
          unless block_given?
            fail SyntaxError, 'Password requires a block'
          end
          delegated.password = Password.build(&block)
        end

        def selinux(value)
          delegated.selinux = value.to_s
        end

        def run_list(value)
          if value.is_a?(String)
            list = value.split(',')
          else
            list = value
          end
          delegated.run_list |= list
        end

        def repo(name, args = {})
          delegated.repos << Repo.build(name, args)
        end

        def package(name)
          delegated.packages << name
        end
      end

      alias_method :id, :name
    end
  end
end
