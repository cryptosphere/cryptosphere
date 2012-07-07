require 'rubygems'
require 'bundler/setup'
require 'cryptosphere'
require 'fileutils'

Root = File.expand_path("../tmp", __FILE__)

FileUtils.rm_rf File.join(Root, "*")
Cryptosphere::Blob.setup :root => Root

module KeyExamples
  def load_fixture_key(name = 'alice.key')
    path = File.expand_path("../fixtures/#{name}", __FILE__)
    Cryptosphere.pubkey_cipher.new(File.read(path))
  end

  def alice_private_key
    @alice_private_key ||= load_fixture_key('alice.key').to_der
  end
  alias_method :example_private_key, :alice_private_key

  def alice_public_key
    @alice_public_key  ||= load_fixture_key('alice.key').public_key.to_der
  end
  alias_method :example_public_key, :alice_public_key

  def bob_private_key
    @bob_private_key ||= load_fixture_key('bob.key').to_der
  end

  def bob_public_key
    @bob_public_key  ||= load_fixture_key('bob.key').public_key.to_der
  end
end

include KeyExamples

# Maximum datagram length the Cryptosphere protocol permits
# Taken from RFC 879 maximum size reassembly buffer
MAX_DATAGRAM_LENGTH = 512
