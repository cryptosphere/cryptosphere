require 'rubygems'
require 'bundler/setup'
require 'cryptosphere'
require 'fileutils'

Root = File.expand_path("../tmp", __FILE__)

FileUtils.rm_rf File.join(Root, "*")
Cryptosphere::Blob.setup :root => Root

def example_private_key
  @key ||= begin
    path = File.expand_path("../fixtures/example.key", __FILE__)
    Cryptosphere.pubkey_cipher.new(File.read(path))
  end
end