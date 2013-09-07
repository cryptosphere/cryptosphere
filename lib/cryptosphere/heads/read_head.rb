require 'rbnacl'
require 'uri'

module Cryptosphere
  module Heads
    # ReadHeads are capable of decrypting a unique position as encrypted by its
    # associated WriteHead.
    class ReadHead
      URI_SCHEME = "crypt.readhead"

      attr_reader :verify_key, :symmetric_key

      # Create a Cryptosphere::ReadHead from a crypto.readhead URI
      #
      # @param uri [String] crypt.readhead URI to initialize from
      # @return [RbNaCl::ReadHead] newly initialized read head object
      def initialize(uri)
        uri = URI(uri) unless uri.is_a? URI # coerce to a URI
        scheme, authority = uri.scheme, uri.opaque
        raise ArgumentError, "not a #{URI_SCHEME}: #{uri}" unless scheme == URI_SCHEME

        # Extract the version byte
        version = authority.slice!(-1)

        # TODO: centralize versioning
        raise "unsupported version: #{version}" unless version == "0"
        keys = Encoding.decode(authority)

        # TODO: length literals suck! (i.e. 64)
        # Replace with a constant or method for the length
        raise ArgumentError, "invalid length for #{URI_SCHEME}: #{keys.length}" if keys.length != 64

        @verify_key    = RbNaCl::SigningKey.new(keys[0,32])
        @symmetric_key = keys[32,64]
      end

      # Read a position, returning a decrypted position object
      #
      # @param position [String, Cryptosphere::Position] position object
      # @return [RbNaCl::Position] position object with decrypted URI
      def read(position, timestamp = nil)
        position = Position.new(position) unless position.is_a? Position

        # TODO: test decrypting positions with the wrong head
        raise ForgeryError, "invalid position for this read head" unless position.public_key == @verify_key.to_bytes

        # TODO: test timestamps!
        if timestamp && timestamp > position.timestamp
          raise InvalidTimestampError, "stale data"
        end

        position.decrypt!(self)
        position
      end
    end
  end
end
