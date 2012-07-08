require 'openssl'

module Cryptosphere
  # Asymmetric encryption cipher: 2048-bit RSA
  class AsymmetricCipher
    KEY_SIZE = 2048

    def self.generate_key
      OpenSSL::PKey::RSA.generate(KEY_SIZE).to_pem
    end

    def initialize(key)
      openssl_key = OpenSSL::PKey::RSA.new(key)

      if openssl_key.private?
        @private_key = openssl_key
        @public_key  = openssl_key.public_key
      else
        @private_key = nil
        @public_key  = openssl_key
      end
    end

    # Serialize canonical private key with Distinguished Encoding Rules (DER)
    def private_key
      @private_key.to_der
    end

    # Serialize private key in Privacy Enhanced Mail (PEM) format
    def private_key_pem
      @private_key.to_pem
    end

    # Is a private key present?
    def private_key?
      !!@private_key
    end

    # Serialize canonical public key with Distinguished Encoding Rules (DER)
    def public_key
      @public_key.to_der
    end

    # Obtain the fingerprint for this public key
    def public_key_fingerprint
      Cryptosphere.kdf(public_key).unpack('H*').first.scan(/.{4}/).join(":")
    end

    # Encrypt a value using the private key
    # Value can be decrypted with the public key
    def private_encrypt(plaintext)
      @private_key.private_encrypt(plaintext)
    end

    # Decrypt a value using the private key
    # Ciphertext must be encrypted with public key
    def private_decrypt(ciphertext)
      @private_key.private_decrypt(ciphertext)
    end

    # Encrypt a value using the public key
    # Value can only be decrypted with the private key
    def public_encrypt(plaintext)
      @public_key.public_encrypt(plaintext)
    end

    # Decrypt a value using the public key
    # Ciphertext must be encrypted with private key
    def public_decrypt(ciphertext)
      @public_key.public_decrypt(ciphertext)
    end
  end
end
