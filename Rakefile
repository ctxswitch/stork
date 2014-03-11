require "bundler/gem_tasks"
require "rake/testtask"

task default: :test

Rake::TestTask.new do |t|
  t.libs.push File.join(File.dirname(__FILE__), 'lib')
  t.test_files = FileList['specs/*_spec.rb']
  t.verbose = true
end

namespace :server do
  require 'midwife'
  desc 'Start the midwife server'
  task :start do
    Midwife.configure do |config|
      config.path = "./specs/files/configs"
      config.pxe_path = './tmp/pxeboot'
      config.chef_validation_key = './specs/files/snakeoil-validation.pem'
      config.chef_client_key = './specs/files/snakeoil-root.pem'
      config.ssh_pubkeys = ['./specs/files/fake.pub']
    end
    mw = Midwife::Server::Control.start
  end

  desc 'Stop the midwife server'
  task :stop do
    mw = Midwife::Server::Control.stop
  end

  desc 'Restart the midwife server'
  task :restart do
    mw = Midwife::Server::Control.restart
  end
end

