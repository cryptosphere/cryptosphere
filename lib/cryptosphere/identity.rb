module Cryptosphere
  class Identity
    def self.generate
      new Cryptosphere.pubkey_cipher.generate(4096).to_der
    end
    
    def initialize(privkey)
      @privkey = Cryptosphere.pubkey_cipher.new privkey
      @id = Cryptosphere.hash_function.digest(@privkey.public_key.to_der)
    end
    
    def id
      @id.unpack('H*').first.scan(/.{4}/).join(":")
    end
    
    def to_s
      "#<Cryptosphere::Identity:#{id}>"
    end
  end
end