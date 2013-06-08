require 'timeout'

desc "Run benchmarks"
task :benchmark do
  glob = File.expand_path("../../benchmarks/*.rb", __FILE__)
  Dir[glob].each { |benchmark| load benchmark }
end
