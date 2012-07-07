module Cryptosphere
  class Identity
    attr_reader :id, :private_key

    def self.generate
      new Cryptosphere.pubkey_cipher.generate(Cryptosphere::PUBKEY_SIZE).to_der
    end

    def initialize(privkey)
      @private_key = Cryptosphere.pubkey_cipher.new(privkey)

      binary_id = Cryptosphere.kdf(@private_key.public_key.to_der)
      @id = binary_id.unpack('H*').first.scan(/.{4}/).join(":")
    end

    def public_key
      @private_key.public_key
    end

    def to_s
      "#<Cryptosphere::Identity:#{id}>"
    end
  end
end
