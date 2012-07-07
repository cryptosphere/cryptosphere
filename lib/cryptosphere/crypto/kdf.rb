require 'hkdf'

module Cryptosphere
  # Cryptographically secure key derivation function: HKDF (RFC 5869)
  #
  # Options:
  # * size: how many bytes of output to generate (default 32, i.e. 256 bits)
  def self.kdf(secret, options = {})
    size = options[:size] || 32
    HKDF.new(secret).next_bytes(size)
  end
end