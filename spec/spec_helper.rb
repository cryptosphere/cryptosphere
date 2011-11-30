require 'rubygems'
require 'bundler/setup'
require 'cryptosphere'
require 'fileutils'

Root = File.expand_path("../tmp", __FILE__)

FileUtils.rm_rf File.join(Root, "*")
Cryptosphere::Node.setup :root => Root