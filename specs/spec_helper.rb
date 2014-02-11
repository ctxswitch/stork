ENV['RACK_ENV'] = 'test'

if ENV['COVERAGE'] == "true"
  require 'simplecov'
  FILTER_DIRS = ['specs']
 
  SimpleCov.start do
    FILTER_DIRS.each{ |f| add_filter f }
  end
end

require 'rubygems'
require 'bundler/setup'
require 'midwife'
require 'minitest/spec'
require 'minitest/autorun'
require 'rack/test'
require 'minitest/pride'

Midwife.configure do |config|
  config.path = File.dirname(__FILE__) + "/files/configs"
end
