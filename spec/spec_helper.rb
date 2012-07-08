require 'rubygems'
require 'bundler/setup'
require 'cryptosphere'
require 'fileutils'

Root = File.expand_path("../tmp", __FILE__)

FileUtils.rm_rf File.join(Root, "*")
Cryptosphere::Blob.setup :root => Root

module KeyExamples
  def load_fixture_private_key(name = 'alice.key')
    File.read File.expand_path("../fixtures/#{name}", __FILE__)
  end

  def load_fixture_public_key(name = 'alice.key')
    Cryptosphere::AsymmetricCipher.new(load_fixture_private_key(name)).public_key
  end

  def alice_private_key
    @alice_private_key ||= load_fixture_private_key('alice.key')
  end
  alias_method :example_private_key, :alice_private_key

  def alice_public_key
    @alice_public_key ||= load_fixture_public_key('alice.key')
  end
  alias_method :example_public_key, :alice_public_key

  def bob_private_key
    @bob_private_key ||= load_fixture_private_key('bob.key')
  end

  def bob_public_key
    @bob_public_key  ||= load_fixture_public_key('bob.key')
  end
end

include KeyExamples

# Maximum datagram length the Cryptosphere protocol permits
# Taken from RFC 879 maximum size reassembly buffer
MAX_DATAGRAM_LENGTH = 512
