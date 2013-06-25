require 'rbnacl'

module Cryptosphere
  module Primitives
    # Blake2bXSalsa20Poly1305 is the underlying encryption primitive used to
    # provide integrity and confidentiality of all objects in the system.
    # The underlying components are:
    #
    # * Blake2b: successor to the "Blake" SHA3 finalist hash function. Performs
    #   faster than MD5 and SHA1 in software, but has security similar to SHA3.
    #   Also provides a HMAC-like keyed mode. Blake2b is used to derive the
    #   symmetric key for the block, based on the combination of the plaintext
    #   of the block and an optional convergence secret which can be used to
    #   deduplicate files among individuals or small groups. Deriving a key
    #   from the contents of the block ensures that every block is encrypted
    #   with a unique key, and also that the same file uploaded multiple times
    #   does not create duplicate objects in the system (at least for a given
    #   convergence secret). The convergence secret can be any string whose
    #   length is 64 bytes or less (i.e. 1 - 64 bytes in length). Blake2b
    #   allows the size of the output hash to be specified (as opposed to
    #   merely truncating the hash). A 256-bit (32-byte) output is used.
    #
    # * XSalsa20Poly1305: The XSalsa20 stream cipher and Poly1305 MAC combined
    #   into a single primitive, as implemented in the Networking and
    #   Cryptography Library by Daniel J. Bernstein. This primitive,
    #   known as "secret_box" within NaCl, provides authenticated symmetric
    #   encryption with a 256-bit key and 192-bit nonce. Because a unique
    #   key is derived for each block, the nonce is always 0.
    #
    # The primitives are combined as follows:
    #
    #     key = Blake2b(plaintext, 32, convergence_secret)
    #     ciphertext = XSalsa20Poly1305Encrypt(key, 0, plaintext)
    #     decrypted_ciphertext = XSalsa20Poly1305Decrypt(key, 0, ciphertext)
    #
    module Blake2bXSalsa20Poly1305
      module_function

      # Fixed nonce to use for all blocks (since they each have a unique key)
      NONCE = "\0" * Crypto::SecretBox.nonce_bytes

      # Derive an encryption key using Blake2b in keyed mode. To achieve
      # convergent encryption, we derive keys from hashes of the plaintext,
      # plus an optional convergence secret
      #
      # @param plaintext [String] plaintext from which a key should be derived
      # @param convergence_secret [String] optional secret value
      # @return [String] derived encryption key
      def derive_key(plaintext, convergence_secret)
        Crypto::Hash.blake2b(
          plaintext,
          digest_size: Crypto::SecretBox.key_bytes,
          key: convergence_secret
        )
      end

      # Encrypt a block's plaintext under this scheme. We can omit a nonce
      # and use an all-zero one because we derive a unique key per block.
      #
      # @param key [String] uniquely derived encryption key to be used
      # @param plaintext [String] plaintext to be encrypted with the given key
      # @return [String] ciphertext for the given inputs
      def encrypt(key, plaintext)
        Crypto::SecretBox.new(key).encrypt(NONCE, plaintext)
      end

      # Decrypt a block using the given key
      #
      # @param key [String] uniquely derived encryption key to be used
      # @param ciphertext [String] ciphertext to be decrypted
      # @return [String] decrypted plaintext
      def decrypt(key, ciphertext)
        Crypto::SecretBox.new(key).decrypt(NONCE, ciphertext)
      end
    end
  end
end