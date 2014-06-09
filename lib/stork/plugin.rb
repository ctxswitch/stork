require 'rest-client'
require 'highline/import'

module Stork
  def self.plugins
    @plugins || []
  end

  def self.add_plugin(plugin)
    plugins << plugin
  end

  class Plugin
    attr_reader :options
    attr_reader :args
    attr_reader :stork

    def self.banner(str)
      @banner = str
    end

    def self.help
      @banner
    end

    def initialize(options, args)
      @action = nil
      @options = options
      @args = args
      @stork = "http://#{Configuration[:server]}:#{Configuration[:port]}"
    end

    def config
      Stork::Configuration
    end

    def fetch(path)
      response = RestClient.get "#{@stork}/api/v1/#{path}"
      data = JSON.parse(response)
    end

    def show(key, data, options = {})
      padding = options.has_key?('pad') ? options['pad'] : 16
      name = key.split('_').map{|k| k.capitalize}.join(' ').ljust(padding)

      if data[key].is_a?(Array)
        if data[key].empty?
          value = "** empty **"
        else
          value = data[key].join(', ')
        end
      elsif data[key].is_a?(NilClass)
        value = "Unset"
      else
        value = data[key]
      end
      say("<%= color('#{name}:', CYAN) %> #{value}")
    end

    def run
      puts "No content"
    end
  end
end