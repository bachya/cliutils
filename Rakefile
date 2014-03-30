require 'rake/clean'
require 'rubygems'

spec = eval(File.read('cliutils.gemspec'))

require 'yard'
desc 'Create YARD documentation'
YARD::Rake::YardocTask.new do |t|
end

require 'rake/testtask'
desc 'Run unit tests'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
end

task :default => [:test]
