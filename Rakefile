# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

def empty_directory(directory)
  FileUtils.remove_entry(directory)
  FileUtils.mkdir(directory)
end

# clean up the workspace
task(:clean) do
  empty_directory('doc')
  empty_directory('out')
  empty_directory('pkg')
end

# unit tests
RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = 'spec/**/*_spec.rb'
  task.rspec_opts = '--require spec_helper ' \
                    '--format documentation ' \
                    '--format html ' \
                    '--out out/rspec_unit.html'
end
task(default: :spec)

# configure rubocop
RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = [
    '--format', 'simple',
    '--format', 'html',
    '--out', 'out/rubocop.html',
    'lib/**/*.rb',
    'spec/**/*.rb'
  ]
end
task(default: :rubocop)

# Require tests, syntax and documentation to pass before building
task(build: %i[spec rubocop])

# Require a succesful build before release
task(release: %i[build])

task(:console) do
  # protect ctrl-c in pry
  trap(:SIGINT) {}
  sh 'bundle exec bin/console'
end
