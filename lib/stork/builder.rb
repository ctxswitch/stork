module Stork
  # The Builder object loads all of the definition files and parses them
  # to build a collection of resources
  #
  class Builder
    attr_reader :collection
    # Initialize the builder object.  Create a new collection.
    #
    def initialize
      @collection = Stork::Collections.new
    end

    # Load the resource definition files.  The snippets and templates
    # are first read in.  Then the rest of the resources will be evalutated
    # and added to the collections.
    #
    # == Returns:
    # A builder object that contains the the resource collections
    #
    def self.load
      builder = Builder.new
      delegator = BuilderDelegator.new(builder)

      # Load in snippets and templates
      delegator.snippets(Configuration[:snippets_path])
      delegator.templates(Configuration[:templates_path])

      load_paths = [
        Configuration[:distros_path],
        Configuration[:chefs_path],
        Configuration[:networks_path],
        Configuration[:layouts_path],
        Configuration[:hosts_path]
      ]

      load_paths.each do |path|
        Dir.glob(path + '/*.rb') do |file|
          delegator.instance_eval(File.read(file))
        end
      end
      builder
    end

    # Expose a limited number of resource methods for DSL parsing from 
    # files.  Allow delegation of the host, layout, network, chef, distro, 
    # templates and snippets blocks.
    #
    # == Parameters
    # obj::
    #   The Builder object that is being delegated.
    #
    class BuilderDelegator 
      def initialize(obj)
        @delegated = obj
      end

      # Build and add a host to the resource collection.
      #
      # == Parameters:
      # name::
      #   The fully qualified domain name of the host.
      #
      # 
      def host(name, &block)
        @delegated.collection.hosts.add(
          Resource::Host.build(
            name,
            collection: @delegated.collection,
            &block
          )
        )
      end


      # Build and add a layout to the resource collection.
      #
      # == Parameters:
      # name::
      #   A unique name to identify the layout.
      #
      # 
      def layout(name, &block)
        @delegated.collection.layouts.add(
          Resource::Layout.build(name, &block)
        )
      end

      # Build and add a network to the resource collection.
      #
      # == Parameters:
      # name::
      #   A unique name to identify the network.
      #
      # 
      def network(name, &block)
        @delegated.collection.networks.add(
          Resource::Network.build(name, &block)
        )
      end

      # Build and add a chef server to the resource collection.
      #
      # == Parameters:
      # name::
      #   A unique name to identify the chef server.
      #
      #
      def chef(name, &block)
        @delegated.collection.chefs.add(
          Resource::Chef.build(name, &block)
        )
      end

      # Build and add a distro to the resource collection.
      #
      # == Parameters:
      # name::
      #   A unique name to identify the distro.
      #
      #
      def distro(name, &block)
        @delegated.collection.distros.add(
          Resource::Distro.build(name, &block)
        )
      end

      # Read and add a template to the resource collection.
      #
      # == Parameters:
      # name::
      #   A unique name to identify the template.
      #
      #
      def templates(path)
        Dir.glob(path + '/*.erb') do |file|
          @delegated.collection.templates.add(
            Resource::Template.new(file)
          )
        end
      end

      # Read and add a snippet to the resource collection.
      #
      # == Parameters:
      # name::
      #   A unique name to identify the snippet.
      #
      #
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
