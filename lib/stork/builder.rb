module Stork
  # The Builder object loads all of the configuration files and parses them
  # to build a collection of resources
  #
  # === Attributes
  # * +configuration+ - The configuration containing the paths to the resource
  #                     files.
  class Builder
    attr_reader :collection
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
      @collection = Stork::Collections.new
    end

    def self.load(configuration)
      builder = Builder.new(configuration)
      delegator = BuilderDelegator.new(builder)

      # Load in snippets and templates
      delegator.snippets(configuration.snippets_path)
      delegator.templates(configuration.templates_path)

      load_paths = [
        configuration.distros_path,
        configuration.chefs_path,
        configuration.networks_path,
        configuration.layouts_path,
        configuration.hosts_path
      ]

      load_paths.each do |path|
        Dir.glob(path + '/*.rb') do |file|
          delegator.instance_eval(File.read(file))
        end
      end
      builder
    end

    # Expose a limited number of methods for DSL parsing from files.  Allow
    # delegation of the host, layout, network, chef, distro, templates and
    # snippets blocks.
    #
    # ==== Attributes
    # * +obj+ - The Builder object that is being delegated.
    class BuilderDelegator
      def initialize(obj)
        @delegated = obj
      end

      def host(name, &block)
        @delegated.collection.hosts.add(
          Resource::Host.build(
            name,
            configuration: @delegated.configuration,
            collection: @delegated.collection,
            &block
          )
        )
      end

      def layout(name, &block)
        @delegated.collection.layouts.add(
          Resource::Layout.build(name, &block)
        )
      end

      def network(name, &block)
        @delegated.collection.networks.add(
          Resource::Network.build(name, &block)
        )
      end

      def chef(name, &block)
        @delegated.collection.chefs.add(
          Resource::Chef.build(name, &block)
        )
      end

      def distro(name, &block)
        @delegated.collection.distros.add(
          Resource::Distro.build(name, &block)
        )
      end

      def templates(path)
        Dir.glob(path + '/*.erb') do |file|
          @delegated.collection.templates.add(
            Resource::Template.new(file)
          )
        end
      end

      def snippets(path)
        Dir.glob(path + '/*.erb') do |file|
          @delegated.collection.snippets.add(
            Resource::Snippet.new(file)
          )
        end
      end
    end
  end
end
