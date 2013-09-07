require 'cryptosphere/version'

require 'cryptosphere/block'
require 'cryptosphere/encoding'
require 'cryptosphere/pkt_line'
require 'cryptosphere/position'

require 'cryptosphere/heads/read_head'
require 'cryptosphere/heads/write_head'

require 'cryptosphere/cli'

module Cryptosphere
  # Size of symmetric keys in bytes (32 bytes, 256-bits)
  SECRET_KEY_BYTES = RbNaCl::SecretBox::KEYBYTES

  # Secure random data source
  def self.random_bytes(size)
    RbNaCl::Random.random_bytes(size)
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
