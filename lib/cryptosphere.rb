require 'digest/sha2'
require 'openssl'
require 'base32'

require 'cryptosphere/version'

require 'cryptosphere/crypto/asymmetric_cipher'
require 'cryptosphere/crypto/kdf'
require 'cryptosphere/crypto/signature_algorithm'

require 'cryptosphere/block'

require 'cryptosphere/cli'
require 'cryptosphere/head'
require 'cryptosphere/identity'

module Cryptosphere
  # How large of a key to use for the pubkey cipher
  PUBKEY_SIZE = 2048

  # Size of symmetric keys in bytes (32 bytes, 256-bits)
  SECRET_KEY_BYTES = Crypto::SecretBox::KEYBYTES

  # Secure random data source
  def self.random_bytes(size)
    OpenSSL::Random.random_bytes(size)
  end

  # 256-bit hash function
  def self.hash_function
    Digest::SHA256.new
  end

  # 256-bit block cipher
  def self.block_cipher
    OpenSSL::Cipher::Cipher.new("aes-256-cbc")
  end

  def self.logger
    Celluloid.logger
  end

  # Encode a string in Zooko-style Base32
  def self.base32_encode(string)
    Base32.encode(string).downcase.sub(/=+$/, '')
  end

  # Decode a Base32 string
  def self.base32_decode(string)
    Base32.decode(string.upcase)
  end

  # Request to do something we're incapable of
  class CapabilityError < StandardError; end

  # Signature doesn't match (potential data tampering)
  class ForgeryError < StandardError; end

  # Implausible timestamps (i.e. ones from the future)
  class InvalidTimestampError < StandardError; end
end
