require 'cryptosphere/version'

require 'cryptosphere/block'
require 'cryptosphere/encoding'
require 'cryptosphere/pkt_line_reader'
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

  # The length prefix specifies a data segment longer than PKT_LEN_MAX
  class LengthError < ArgumentError; end

  # Malformatted data was encountered
  class FormatError < StandardError; end

  # An unexpected message was encountered
  class ProtocolError < FormatError; end

  # Request to do something we're incapable of
  class CapabilityError < StandardError; end

  # Signature doesn't match (potential data tampering)
  class ForgeryError < StandardError; end

  # Implausible timestamps (i.e. ones from the future)
  class InvalidTimestampError < StandardError; end

  # Secure random data source
  def self.random_bytes(size)
    Crypto::Random.random_bytes(size)
  end

  def self.logger
    Celluloid.logger
  end
end
