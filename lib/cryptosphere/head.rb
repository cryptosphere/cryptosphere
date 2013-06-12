module Cryptosphere
  class Head
    attr_reader :signing_key, :read_key, :verify_key, :timestamp

    def self.generate
      access_key = AsymmetricCipher.generate_key
      read_key   = Cryptosphere.random_bytes(32)

      new(verify_key.to_der, read_key, signing_key.to_der)
    end

    def initialize(access_key, read_key = nil)
      @signing_cipher = AsymmetricCipher.new(access_key)
      @read_key      = read_key

      @id        = @signing_cipher.public_key_fingerprint
      @location  = nil
      @timestamp = nil
    end

    def location
      raise CapabilityError, "can't read location" unless @read_key
      @location
    end

    def move(location, timestamp = Time.now)
      raise CapabilityError, "don't have write capability" unless @signing_cipher.private_key?
      @location, @timestamp = location, timestamp
    end
    alias_method :location=, :move

    def to_signed_message
      cipher = Cryptosphere.block_cipher
      cipher.encrypt
      cipher.key = @read_key
      cipher.iv  = iv = cipher.random_iv

      ciphertext = cipher.update(location)
      ciphertext << cipher.final

      message   = [@timestamp.to_i, iv, ciphertext].pack("QA16A*")
      signature = @signing_cipher.private_encrypt Cryptosphere.kdf(message)

      [signature.size, signature, message].pack("nA*A*")
    end

    def update(signed_message)
      signature_size, rest = signed_message.unpack("nA*")
      signature, message = rest.unpack("A#{signature_size}A*")

      if @signing_cipher.public_decrypt(signature) != Cryptosphere.kdf(message)
        raise ForgeryError, "signature does not match message"
      end

      timestamp, iv, ciphertext = message.unpack("QA16A*")
      timestamp = Time.at(timestamp)

      if timestamp > Time.now
        raise InvalidTimestampError, "timestamp is in the future"
      elsif @timestamp && timestamp < @timestamp
        return false # we have a newer version
      end

      if @read_key
        cipher = Cryptosphere.block_cipher
        cipher.decrypt
        cipher.key = @read_key
        cipher.iv = iv

        location = cipher.update(ciphertext)
        location << cipher.final

        @location = location
      end
    end
  end
end
