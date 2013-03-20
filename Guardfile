# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :bundler do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  watch(/^.+\.gemspec/)
end

guard :minitest, test_folders: 'test', test_file_patterns: '*.rb' do
  watch(%r{^test/.+\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "test/#{m[1]}.rb" }
  watch(%r|^test/pavlov\.rb|)    { "test" }
end
