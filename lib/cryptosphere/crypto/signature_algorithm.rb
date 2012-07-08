module Cryptosphere
  # Sign the given message with a private key
  def self.sign(key, message)
    AsymmetricCipher.new(key).private_encrypt(kdf(message))
  end

  # Verify a message with the public key. Returns if the signature matches,
  # and false if there's a mismatch
  def self.verify(key, message, signature)
    AsymmetricCipher.new(key).public_decrypt(signature) == kdf(message)
  end

  # Verify a message, raising InvalidSignatureError on signature mismatch
  def self.verify!(key, message, signature)
    verify(key, message, signature) or raise InvalidSignatureError, "signature mismatch"
  end
end