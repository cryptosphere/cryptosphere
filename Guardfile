# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb') { "spec" }
  watch('spec/integration_helper.rb') { "spec" }

  # Unit tests
  watch('lib/cryptosphere.rb')   { "spec" }
  watch(%r{^lib/(.+)\.rb$})      { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)head\.rb$}) { |m| "spec/cryptosphere/head_spec.rb" }

  # Integration tests
  watch(%r{^lib/cryptosphere/(.+)\.rb$}) { |m| "spec/integration/#{m[1]}_spec.rb" }
end

