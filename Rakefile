require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs = ['lib']
  t.warning = true
  t.verbose = true
  t.test_files = FileList['tests/**/*.rb']
end
