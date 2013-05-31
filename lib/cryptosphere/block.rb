require 'cryptosphere/block/blake2bxsalsa20poly1305'

module Cryptosphere
  # Blocks are the underlying convergent encryption primitive used by the
  # Cryptosphere for data confidentiality. If you are looking for the secret
  # sauce, welcome my friend, you have found the right place.
  #
  # Blocks provide for both data integrity and confidentiality for plaintexts
  # between 0 bytes and 1048576 bytes (1 mebibyte). Blocks are encrypted using
  # a convergent encryption technique known as content hash keying. With this
  # approach, a cryptographic hash of the file's contents is calculated.
  # Together with an optional random key known as a "convergence secret",
  # a symmetric key is derived, which is used to encrypt the file with an
  # authenticated symmetric cipher.
  #
  # For more specifics on the encryption, please see Blake2bXSalsa20Poly1305
  class Block
    # Hard limit on the size of a block
    SIZE_LIMIT = 1_048_576

    # Encryption primitive to use (we only support one now but might support
    # more in the future)
    PRIMITIVE = Blake2bXSalsa20Poly1305

    def self.encrypt(plaintext, convergence_secret = nil)
      key = PRIMITIVE.derive_key(plaintext, convergence_secret)
      new(PRIMITIVE.encrypt(key, plaintext), key)
    end

    attr_reader :key, :ciphertext, :plaintext

    # Create a new block from it's ciphertext. Specify a key to allow decryption
    def initialize(ciphertext, key = nil)
      @key = key

      @ciphertext = ciphertext
      @plaintext  = PRIMITIVE.decrypt(key, ciphertext) if key
    end
  end
end
