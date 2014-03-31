module Midwife
  class Collection
    attr_reader :hosts
    attr_reader :layouts
    attr_reader :networks
    attr_reader :chefs
    attr_reader :distros
    attr_reader :snippets
    attr_reader :templates

    def initialize
      @hosts = Midwife::Collections::Host.new
      @layouts = Midwife::Collections::Layout.new
      @networks = Midwife::Collections::Network.new
      @chefs = Midwife::Collections::Chef.new
      @distros = Midwife::Collections::Distro.new
      @snippets = Midwife::Collections::Snippet.new
      @templates = Midwife::Collections::Template.new
    end
  end
end
