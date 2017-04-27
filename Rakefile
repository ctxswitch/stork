require "bundler/gem_tasks"
require "rake/testtask"

task default: :test

Rake::TestTask.new do |t|
  t.libs.push File.join(File.dirname(__FILE__), 'lib')
  t.test_files = FileList['specs/*_spec.rb']
  t.verbose = true
end

namespace :ksvalidator do
  desc 'Set up the validation directories and environment.'
  task :setup do
    spath = File.join(File.dirname(__FILE__), 'specs', 'scripts', 'kssetup.sh')
    system("sh #{spath}")
  end

  task :clean do
    vpath = File.join(File.dirname(__FILE__), 'specs', 'ksvalidator')
    FileUtils.rm_rf(Dir.glob("#{vpath}/*"))
  end
end
