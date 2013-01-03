# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :bundler do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  watch(/^.+\.gemspec/)
end

guard 'minitest' do
  watch(%r{^tests/.+\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}.rb" }
end
