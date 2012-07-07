require 'spec_helper'

describe Cryptosphere::Handshake do
  let(:alice) { Cryptosphere::Identity.new(alice_private_key) }
  let(:bob)   { Cryptosphere::Identity.new(bob_private_key) }

  it "encodes and decodes request packets" do
    handshake = Cryptosphere::Handshake::RequestEncoder.new(alice, bob)
    packet = handshake.to_signed_message

    # FIXME: need elliptic curve crypto here for smaller packets
    #packet.length.should be < MAX_DATAGRAM_LENGTH
    request = Cryptosphere::Handshake::RequestDecoder.new(bob, packet)
    request.public_key.to_der.should eq alice.public_key.to_der
  end
end
