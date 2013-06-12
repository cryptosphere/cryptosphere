require 'spec_helper'

describe Cryptosphere::Block do
  let(:block_id)  { "xnl6nmgbbhzhuls7urd2d2twyfc32nqwn77hcsly47kg2rew3vca" }
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
