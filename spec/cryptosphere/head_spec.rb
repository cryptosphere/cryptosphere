require 'spec_helper'

describe Cryptosphere::Head do
  let(:read_key)   { "X" * 32 }
  let(:write_key)  { example_private_key }
  let(:verify_key) { example_public_key }

  let(:reader) { Cryptosphere::Head.new(verify_key, read_key) }
  let(:writer) { Cryptosphere::Head.new(verify_key, read_key, write_key) }

  let(:example_location) { "221B Baker Street" }

  it "moves heads" do
    writer.move(example_location)
    message = writer.to_signed_message
    message.length.should be < MAX_DATAGRAM_LENGTH

    reader.update message
    reader.location.should == example_location
  end
end
