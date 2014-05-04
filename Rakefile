require 'rake/clean'
require 'rubygems'

def version
  contents = File.read File.expand_path('../lib/cliutils/constants.rb', __FILE__)
  contents[/VERSION = '([^']+)'/, 1]
end

spec = eval(File.read('cliutils.gemspec'))

require 'yard'
desc 'Create YARD documentation'
YARD::Rake::YardocTask.new do |t|
end

require 'rspec/core/rake_task'
desc "Run the specs."
RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.verbose = false
end

desc "Release CLIUtils version #{version}"
task :release => :build do
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end

  sh "git commit --allow-empty -a -m 'Release #{version}'"
  sh "git tag v#{version}"
  sh "git push origin master"
  sh "git push origin v#{version}"
  sh "gem push pkg/cliutils-#{version}.gem"
end

desc "Build the gem"
task :build do
  FileUtils.mkdir_p "pkg"
  sh "gem build cliutils.gemspec"
  FileUtils.mv("./cliutils-#{version}.gem", "pkg")
end

task :default => [:spec, :yard]
