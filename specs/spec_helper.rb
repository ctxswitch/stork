ENV['RACK_ENV'] = 'test'

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
elsif ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    ['specs', 'vendor'].each{ |f| add_filter f }
  end
end

require 'rubygems'
require 'bundler/setup'
require 'midwife'
require 'minitest/spec'
require 'minitest/autorun'
require 'rack/test'
require 'minitest/pride'
require 'minitest/given'

if ENV['DEBUG']
  require 'minitest/debugger'
end

Midwife.configure do |config|
  config.path = File.dirname(__FILE__) + "/files/configs"
  config.pxe_path = File.dirname(__FILE__) + '/tmp/pxeboot'
  config.authorized_keys = File.read(File.dirname(__FILE__) + '/files/fake.pub')
end
