require 'spec_helper'

describe Cryptosphere::Block do
  let(:plaintext) { "Stellar Wind is watching you" }

  it "encrypts and decrypts blocks" do
    block = described_class.encrypt(plaintext)
    block.should be_a described_class

    decrypted_block = described_class.new(block.ciphertext, block.key)

    decrypted_block.id.should eq "gtg2pd663z6crgyqwnzys4b5whxodn4dvdhxepzt6hshtp2u4oia"
    decrypted_block.key.should eq block.key
    decrypted_block.ciphertext.should eq block.ciphertext
    decrypted_block.plaintext.should eq plaintext
  end
end