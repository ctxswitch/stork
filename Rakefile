require "bundler/gem_tasks"
require "rake/testtask"

task default: :test

Rake::TestTask.new do |t|
  t.libs.push File.join(File.dirname(__FILE__), 'lib')
  t.test_files = FileList['specs/*_test.rb']
  t.verbose = true
end

