require 'base32'
require 'cryptosphere/block/primitive/blake2bxsalsa20poly1305'

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
    # Hash key to use when calculating the ID of a block
    # This matches the URI scheme for blocks
    HASH_KEY = "crypt.block"

    # Hard limit on the size of a block
    SIZE_LIMIT = 1_048_576

    # Encryption primitive to use (we only support one now but might support
    # more in the future)
    DEFAULT_PRIMITIVE = Primitive::Blake2bXSalsa20Poly1305

    def self.encrypt(plaintext, convergence_secret = nil)
      key        = DEFAULT_PRIMITIVE.derive_key(plaintext, convergence_secret)
      ciphertext = DEFAULT_PRIMITIVE.encrypt(key, plaintext)
      id         = DEFAULT_PRIMITIVE.derive_key(ciphertext, HASH_KEY)

      # We can safely skip ID verification because we just computed
      # the ID of the hash ourselves, and we trust ourself, right?
      new(id, ciphertext, key: key, skip_id_check: true)
    end

    attr_reader :raw_id, :key, :ciphertext, :plaintext

    # Create a new block from it's ciphertext. Specify a key to allow decryption
    def initialize(id, ciphertext, options = {})
      # Allow id to be specified as either raw bytes or Base32
      if id.length == SECRET_KEY_BYTES
        @id = id
      else
        @id = Encoding.decode(id)
      end

      # Verify the ID of the content matches the ciphertext
      # We can't rely on the MAC alone because anyone with the key can produce
      # ciphertexts under the same key which are not the ciphertext we're looking for
      unless options.fetch(:skip_id_check, false)
        expected_id = DEFAULT_PRIMITIVE.derive_key(ciphertext, HASH_KEY)
        raise ForgeryError, "forged block!" unless Crypto::Util.verify32(@id, expected_id)
      end

      @key = options.fetch(:key, nil)
      @ciphertext = ciphertext
      @plaintext  = DEFAULT_PRIMITIVE.decrypt(key, ciphertext) if key
    end

    # Return the ID of this block in Base32 format
    def id
      Encoding.encode @id
    end
  end
end
