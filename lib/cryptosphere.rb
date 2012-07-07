require 'digest/sha2'
require 'openssl'
require 'cryptosphere/version'

require 'cryptosphere/crypto/kdf'

require 'cryptosphere/blobs/blob'
require 'cryptosphere/blobs/tree'

require 'cryptosphere/protocol/handshake'

require 'cryptosphere/cli'
require 'cryptosphere/head'
require 'cryptosphere/identity'

module Cryptosphere
  # How large of a key to use for the pubkey cipher
  PUBKEY_SIZE = 2048

  # 2048-bit pubkey cipher
  # TODO: investigate ECDSA as an alternative
  def self.pubkey_cipher
    OpenSSL::PKey::RSA
  end

  # 256-bit hash function
  def self.hash_function
    Digest::SHA256.new
  end

  # Signature function
  def self.sign(key, message)
    key.private_encrypt(kdf(message))
  end

  # Signature verification function
  def self.verify(key, message, signature)
    key.public_decrypt(signature) == kdf(message)
  end

  # Signature verification function that raises InvalidSignatureError
  def self.verify!(key, message, signature)
    verify(key, message, signature) or raise InvalidSignatureError, "signature mismatch"
  end

  # 256-bit block cipher
  def self.block_cipher
    OpenSSL::Cipher::Cipher.new("aes-256-cbc")
  end

  # Request to do something we're incapable of
  class CapabilityError < StandardError; end

  # Signature doesn't match (potential data tampering)
  class InvalidSignatureError < StandardError; end

  # Implausible timestamps (i.e. ones from the future)
  class InvalidTimestampError < StandardError; end
end
