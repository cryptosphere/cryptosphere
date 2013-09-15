require 'rbnacl'
require 'uri'

module Cryptosphere
  # Encrypted positions of objects in the system. Can be decrypted by
  # ReadHeads, or repaired by RepairHeads
  class Position
    attr_reader :public_key, :timestamp, :ciphertext, :signature

    # Create a new position object using the given WriteHead
    #
    # @param write_head [WriteHead] write head object to record this position with 
    # @return [Cryptosphere::WriteHead] newly generated WriteHead object
    def self.record(write_head, uri, timestamp = Time.now)
      # TODO: pack sucks, get rid of it :(
      box = RbNaCl::RandomNonceBox.new RbNaCl::SecretBox.new(write_head.symmetric_key)
      ciphertext = box.box(uri)

      public_key = write_head.signing_key.verify_key.to_bytes
      message    = [@timestamp.to_i, ciphertext].pack("QA*")
      signature  = write_head.signing_key.sign(message)

      new(public_key + signature + message)
    end

    # Create a new Cryptosphere::Position from the given components
    #
    # @param position_string [String] Serialized position object as bytes
    # @return [RbNaCl::Position] newly initialized position object
    def initialize(position_string)
      # TODO: hardcoded lengths suck!
      raise ArgumentError, "too short" unless position_string.length > 96
      @public_key = position_string[0,32]
      @signature  = position_string[32,64]
      message     = position_string[96..-1]

      verify_key = RbNaCl::VerifyKey.new(@public_key)

      # TODO: raise a better exception here if the position fails to verify
      verify_key.verify!(signature, message)

      timestamp, ciphertext = message.unpack("QA*")
      raise InvalidTimestampError, "timestamp is in the future" if timestamp > Time.now.utc.to_i

      @timestamp  = Time.at(timestamp)
      @ciphertext = ciphertext
      @uri = nil
    end

    # Decrypt this position
    #
    # @param read_head [Cryptosphere::ReadHead] read head to decrypt with
    # @return [true] Position was successfully decrypted
    def decrypt!(read_head)
      box = RbNaCl::RandomNonceBox.new RbNaCl::SecretBox.new(read_head.symmetric_key)
      @uri = box.open(@ciphertext)
      true
    end

    # Return the URI represented by this position (if decrypted)
    #
    # @return [String] URI this position points to
    def uri
      @uri or raise CapabilityError, "position has not been decrypted"
    end

    # Return the byte representation of this position object
    #
    # @return [RbNaCl::Position] newly initialized position object
    def to_bytes
      message = [@timestamp.to_i, @ciphertext].pack("QA*")
      @public_key + @signature + message
    end
    alias to_s to_bytes
  end
end
