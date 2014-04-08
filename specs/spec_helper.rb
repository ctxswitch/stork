ENV['RACK_ENV'] = 'test'

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
elsif ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    ['specs', 'vendor', 'lib/midwife/server/control.rb'].each{ |f| add_filter f }
  end
end

require 'rubygems'
require 'bundler/setup'
require 'midwife'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/given'
require 'open3'

if ENV['DEBUG']
  require 'minitest/debugger'
end

def configuration
  @configuration ||= Midwife::Configuration.from_file('./specs/files/configs/midwife/test.rb')
end

def collection
  @collection ||= Midwife::Builder.load(configuration).collection
end
