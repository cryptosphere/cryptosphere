require 'spec_helper'

describe Cryptosphere::Head do
  let(:verify_key) { example_private_key.public_key.to_der }
  let(:read_key)   { "X" * 32 }
  let(:write_key)  { example_private_key  }

  let(:reader) { Cryptosphere::Head.new(verify_key, read_key) }
  let(:writer) { Cryptosphere::Head.new(verify_key, read_key, write_key) }

  let(:example_location) { "221B Baker Street" }

  it "moves heads" do
    writer.move(example_location)
    reader.update writer.to_signed_message
    reader.location.should == example_location
  end
end
