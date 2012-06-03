require 'digest/sha2'
require 'openssl'
require 'pbkdf2'
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

  # 512-bit KDF (256-bit key, 256-bit iv)
  def self.kdf(secret, salt, iterations = 20000)
    PBKDF2.new(
      :password   => secret,
      :salt       => salt,
      :iterations => iterations,
      :key_length => 64
    ).bin_string
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
