require 'cryptosphere/version'

require 'cryptosphere/node'
require 'cryptosphere/node_builder'

module Cryptosphere
  # The Cryptosphere shares an initialization vector for all nodes
  # TODO: hey any crypto people who know more than me, does this seem bad?
  CONVERGENCE_NONSECRET = "\x0\x1\x2\x3\x4\x5\x6\x7\x8\x9\xa\xb\xc\xd\xe\xf"
  
  def self.hash_cipher
    Digest::SHA2.new
  end
  
  def self.block_cipher
    OpenSSL::Cipher::Cipher.new("aes-256-cbc")
  end
end
