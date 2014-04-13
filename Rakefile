require "bundler/gem_tasks"

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
    vpath = File.join(File.dirname(__FILE__), 'specs', 'tmp')
    puts "Setting up in #{vpath}"
    system("mkdir -p #{vpath} ; cd #{vpath} ; sh #{spath}")
  end

  task :clean do
    vpath = File.join(File.dirname(__FILE__), 'specs', 'tmp', 'ksvalidator')
    system("rm -rf #{vpath}")
  end
end
