ENV['RACK_ENV'] = 'test'
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
