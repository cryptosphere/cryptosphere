require 'digest/sha2'
require 'openssl'
require 'hkdf'
require 'cryptosphere/version'

require 'cryptosphere/blobs/blob'
require 'cryptosphere/blobs/tree'
require 'cryptosphere/bucket'
require 'cryptosphere/cli'
require 'cryptosphere/identity'

module Cryptosphere
  # 256-bit hash function
  def self.hash_function
    Digest::SHA256.new
  end

  # Key derivation function
  def self.kdf(secret, size = 32)
    HKDF.new(secret).next_bytes(size)
  end

  # 256-bit block cipher
  def self.block_cipher
    OpenSSL::Cipher::Cipher.new("aes-256-cbc")
  end

  # 4096-bit pubkey cipher
  # TODO: investigate ECDSA as an alternative
  def self.pubkey_cipher
    OpenSSL::PKey::RSA
  end
end
