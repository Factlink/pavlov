guard :bundler do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
end
