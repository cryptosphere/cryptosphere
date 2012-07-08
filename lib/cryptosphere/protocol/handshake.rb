module Cryptosphere
  module Handshake
    class RequestEncoder
      def initialize(sender, recipient)
        @sender, @recipient = sender, recipient
      end

      def to_signed_message
        # FIXME: We need a different algorithm for this to be possible
        # Sure would be nice to have some Curve25519 here
        # message = @recipient.public_key.public_encrypt @sender.public_key
        message = @sender.public_key

        Cryptosphere.sign(@sender.private_key, message) + message
      end
    end

    class RequestDecoder
      attr_reader :public_key

      def initialize(recipient, message)
        signature = message.slice!(0, PUBKEY_SIZE / 8)

        # FIXME: Use some crypto here
        sender_key = message
        Cryptosphere.verify!(sender_key, message, signature)

        @public_key = sender_key
      end
    end
  end
end
