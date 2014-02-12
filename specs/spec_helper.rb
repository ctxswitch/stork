ENV['RACK_ENV'] = 'test'

if ENV['TRAVIS']
    require 'coveralls'
    Coveralls.wear!
elsif ENV['COVERAGE']
  require 'simplecov'
  FILTER_DIRS = ['specs', 'vendor']
 
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
  config.pxe_path = File.dirname(__FILE__) + '/tmp/pxeboot'
  config.chef_validation_key = File.read(File.dirname(__FILE__) + '/files/snakeoil-validation.pem')
  config.chef_client_key = File.read(File.dirname(__FILE__) + '/files/snakeoil-root.pem')
  config.ssh_pubkeys = [File.read(File.dirname(__FILE__) + '/files/fake.pub')]
end
