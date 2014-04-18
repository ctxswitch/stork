module Stork
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
      delegator.snippets(configuration.snippets_path)
      delegator.templates(configuration.templates_path)
      [ configuration.distros_path,
        configuration.chefs_path,
        configuration.networks_path,
        configuration.layouts_path,
        configuration.hosts_path ].each do |path|
        Dir.glob(path + "/*.rb") do |file|
          delegator.instance_eval(File.read(file))
        end
      end
      builder
    end

    class BuilderDelegator
      def initialize(obj)
        @delegated = obj
      end

      def host(name, &block)
        @delegated.collection.hosts.add(
          Resource::Host.build(@delegated.configuration, @delegated.collection, name, &block)
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
        Dir.glob(path + "/*.erb") do |file|
          @delegated.collection.templates.add(
            Resource::Template.new(file)
          )
        end
      end

      def snippets(path)
        Dir.glob(path + "/*.erb") do |file|
          @delegated.collection.snippets.add(
            Resource::Snippet.new(file)
          )
        end
      end
    end
  end
end
