require 'coveralls'
require 'json'
Coveralls.wear!

require 'rubygems'
require 'bundler/setup'
require 'cryptosphere'
require 'webmachine/test'
require 'pathname'

def fixture(name)
  Pathname.new(File.expand_path("../fixtures", __FILE__)).join(name.to_s).read
end
