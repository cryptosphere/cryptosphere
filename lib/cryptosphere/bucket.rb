module Cryptosphere
  class Bucket
    def self.generate
      signing_key = Cryptosphere.pubkey_cipher.generate(4096)
      verify_key  = signing_key.public_key
      read_key    = OpenSSL::Random.random_bytes(32)

      new(verify_key.to_der, read_key, signing_key.to_der)
    end

    def initialize(verify_key, read_key = nil, signing_key = nil)
      @signing_key = Cryptosphere.pubkey_cipher.new(signing_key) if signing_key
      @read_key    = read_key
      @verify_key  = Cryptosphere.pubkey_cipher.new(verify_key)

      @id = Cryptosphere.kdf(verify_key).unpack("H*").first
    end
  end
end
