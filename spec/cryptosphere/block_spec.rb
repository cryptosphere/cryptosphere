require 'spec_helper'

describe Cryptosphere::Block do
  let(:block_id)  { "bjktwphz5gnw6k6phjbuzugry7qnc5tgv6wlaqbkvjrwr3bit27a" }
  let(:plaintext) { "Stellar Wind is watching you" }

  it "encrypts and decrypts blocks" do
    block = described_class.encrypt(plaintext)
    block.should be_a described_class
    block.id.should eq block_id
    block.plaintext.should eq plaintext

    decrypted_block = described_class.new(block_id, block.ciphertext, key: block.key)

    decrypted_block.id.should  eq block_id
    decrypted_block.key.should eq block.key
    decrypted_block.ciphertext.should eq block.ciphertext
    decrypted_block.plaintext.should  eq plaintext
  end
end
