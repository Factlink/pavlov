# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :bundler do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  watch(/^.+\.gemspec/)
end

guard :minitest, test_folders: 'tests', test_file_patterns: '*.rb' do
  watch(%r{^tests/.+\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "tests/lib/#{m[1]}.rb" }
  watch(%r|^tests/pavlov\.rb|)    { "tests" }
end
