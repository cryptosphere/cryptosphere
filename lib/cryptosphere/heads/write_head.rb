require 'rbnacl'
require 'uri'

module Cryptosphere
  module Heads
    # WriteHeads are capable of of creating new Cryptosphere::Position objects
    # which identify the locations of content trees in the system, much like
    # git's heads. It degrades into a ReadHead, thus anyone with a WriteHead
    # can also read
    class WriteHead
      URI_SCHEME = "crypt.writehead"

      attr_reader :signing_key, :symmetric_key

      # Generate a new WriteHead from a random string
      #
      # @param seed [String] (optional) seed value to generate WriteHead from
      # @return [Cryptosphere::WriteHead] newly generated WriteHead object
      def self.generate(seed = Cryptosphere.random_bytes(64))
        hash = RbNaCl::Hash.blake2b(seed)
        new("#{URI_SCHEME}:#{Encoding.encode(hash) + '0'}")
      end

      # Create a Cryptosphere::WriteHead from a crypto.writehead URI
      #
      # @param uri [String] crypt.writehead URI to initialize from
      # @return [Cryptosphere::Heads::WriteHead] newly initialized write head object
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

        @signing_key   = RbNaCl::SigningKey.new(keys[0,32])
        @symmetric_key = keys[32,32]

        # Calculate this lazily upon request
        @read_head = nil
      end

      # Set the head's position to the given Cryptosphere URI
      #
      # @param uri [String] A Cryptosphere URI the head points to
      # @return [Cryptosphere::Position] New position, signed by this WriteHead
      def set_uri(uri)
        Cryptosphere::Position.record(self, uri)
      end

      # The ReadHead associated with this WriteHead
      # Points to the same location, but can only read, not write
      def read_head
        @read_head ||= begin
          verify_key = @signing_key.verify_key.to_bytes

          # TODO: centralize versioning
          authority = Encoding.encode(verify_key + @symmetric_key) + "0"
          ReadHead.new("crypt.readhead:#{authority}")
        end
      end
    end
  end
end
