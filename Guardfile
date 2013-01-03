# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :bundler do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  watch(/^.+\.gemspec/)
end

guard :minitest do
  watch(%r{^tests/.+\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}.rb" }
  watch('tests/pavlov.rb')  { "tests" }
end

guard :rspec do
  watch(%r{^tests/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "tests/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
