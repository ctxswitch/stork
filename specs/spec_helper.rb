ENV['RACK_ENV'] = 'test'

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
elsif ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    ['specs', 'vendor', 'lib/stork/server/control.rb'].each{ |f| add_filter f }
  end
end

require 'rubygems'
require 'bundler/setup'
require 'stork'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/given'
require 'open3'
require 'fileutils'

if ENV['DEBUG']
  require 'minitest/debugger'
end

def load_config
  Stork::Configuration.from_file('./specs/stork/config.rb')
end

def collection
  Stork::Builder.load.collection
end