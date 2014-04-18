require 'stork/collection/base'
require 'stork/collection/chefs'
require 'stork/collection/distros'
require 'stork/collection/hosts'
require 'stork/collection/layouts'
require 'stork/collection/networks'
require 'stork/collection/snippets'
require 'stork/collection/templates'

module Stork
  class Collections
    attr_reader :hosts
    attr_reader :layouts
    attr_reader :networks
    attr_reader :chefs
    attr_reader :distros
    attr_reader :snippets
    attr_reader :templates

    def initialize
      @hosts = Stork::Collection::Hosts.new
      @layouts = Stork::Collection::Layouts.new
      @networks = Stork::Collection::Networks.new
      @chefs = Stork::Collection::Chefs.new
      @distros = Stork::Collection::Distros.new
      @snippets = Stork::Collection::Snippets.new
      @templates = Stork::Collection::Templates.new
    end

    alias_method :network, :networks
    alias_method :layout, :layouts
    alias_method :host, :hosts
    alias_method :chef, :chefs
    alias_method :distro, :distros
    alias_method :snippet, :snippets
    alias_method :template, :templates
  end
end
