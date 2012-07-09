module Cryptosphere
  module Handshake
    module_function

    def encode_request(sender, recipient)
      # TODO: encrypt sender's public key
      # Sure would be nice to have some Curve25519 here
      message = sender.public_key
      Cryptosphere.sign(sender.private_key, message) + message
    end

    def decode_request(recipient, message)
      bytes = PUBKEY_SIZE / 8
      signature, message = message[0...bytes], message[bytes..-1]

      # FIXME: this should be encrypted :(
      sender_key = message
      Cryptosphere.verify!(sender_key, message, signature)

      sender_key
    end

    def encode_response(sender, recipient, secret = Cryptosphere.random_bytes(32))
      cipher = AsymmetricCipher.new(recipient.public_key)
      message = cipher.public_encrypt(secret)
      Cryptosphere.sign(sender.private_key, message) + message
    end

    def decode_response(recipient, sender, message)
      bytes = PUBKEY_SIZE / 8
      signature, message = message[0...bytes], message[bytes..-1]
      Cryptosphere.verify!(sender.public_key, message, signature)
      cipher = AsymmetricCipher.new(recipient.private_key)
      cipher.private_decrypt(message)
    end
  end
end
