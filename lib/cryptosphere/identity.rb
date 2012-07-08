module Cryptosphere
  class Identity
    attr_reader :id

    extend Forwardable
    def_delegators :@cipher, :private_key, :public_key

    def self.generate
      new AsymmetricCipher.generate_key
    end

    def initialize(private_key)
      @cipher = AsymmetricCipher.new(private_key)
      @id     = @cipher.public_key_fingerprint
    end

    def to_s
      "#<Cryptosphere::Identity:#{id}>"
    end
  end
end
