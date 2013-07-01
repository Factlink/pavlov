require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

desc "Run the benchmarks for pavlov."
task :benchmark do
  ruby "benchmark/pavlov/entity.rb"
  ruby "benchmark/pavlov/immutable_entity.rb"
end

desc "Look for TODO, FIXME and TBD tags in the code. (not case sensitive)"
task :todo do
  RUBY_FILES = FileList['**/*.rb'].exclude('pkg')
  RUBY_FILES.egrep(/#.*(FIXME|TODO|TBD)/i)
end

# Make running the tests the default task.
task(default: :spec)
