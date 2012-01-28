require 'digest/sha2'
require 'openssl'

require 'cryptosphere/version'
require 'cryptosphere/cli'
require 'cryptosphere/identity'

require 'cryptosphere/data/node'
require 'cryptosphere/data/tree'

module Cryptosphere
  def self.hash_cipher
    Digest::SHA2.new
  end
  
  def self.block_cipher
    OpenSSL::Cipher::Cipher.new("aes-256-cbc")
  end
  
  def self.pubkey_cipher
    OpenSSL::PKey::RSA
  end
end
