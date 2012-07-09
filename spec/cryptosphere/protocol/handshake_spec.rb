require 'spec_helper'

describe Cryptosphere::Handshake do
  let(:alice)  { Cryptosphere::Identity.new(alice_private_key) }
  let(:bob)    { Cryptosphere::Identity.new(bob_private_key) }
  let(:secret) { "X" * 32 }

  it "encodes and decodes request packets" do
    packet = Cryptosphere::Handshake.encode_request(alice, bob)

    # FIXME: need elliptic curve crypto here for smaller packets
    #packet.length.should be < MAX_DATAGRAM_LENGTH
    public_key = Cryptosphere::Handshake.decode_request(bob, packet)
    public_key.should eq alice.public_key
  end

  it "encodes and decodes response packets" do
    packet   = Cryptosphere::Handshake.encode_response(bob, alice, secret)
    response = Cryptosphere::Handshake.decode_response(alice, bob, packet)
    response.should eq secret
  end
end
