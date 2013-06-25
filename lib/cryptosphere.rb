require 'cryptosphere/version'

require 'cryptosphere/block'
require 'cryptosphere/encoding'
require 'cryptosphere/position'

require 'cryptosphere/head/read_head'
require 'cryptosphere/head/write_head'

require 'cryptosphere/cli'

module Cryptosphere
  # How large of a key to use for the pubkey cipher
  PUBKEY_SIZE = 2048

  # Size of symmetric keys in bytes (32 bytes, 256-bits)
  SECRET_KEY_BYTES = Crypto::SecretBox::KEYBYTES

  # Secure random data source
  def self.random_bytes(size)
    Crypto::Random.random_bytes(size)
  end

  def self.logger
    Celluloid.logger
  end

  # Request to do something we're incapable of
  class CapabilityError < StandardError; end

  # Signature doesn't match (potential data tampering)
  class ForgeryError < StandardError; end

  # Implausible timestamps (i.e. ones from the future)
  class InvalidTimestampError < StandardError; end
end
