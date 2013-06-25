require 'spec_helper'

describe Cryptosphere::Heads::WriteHead do
  subject { described_class.generate("foobar") }

  let(:read_head) { subject.read_head }
  let(:example_uri) { "crypt:221B+Baker+Street" }

  it "moves heads" do
    position = subject.set_uri(example_uri)
    message  = position.to_s

    new_position = read_head.read(message)
    new_position.uri.should eq example_uri
  end

  it "raises if given the wrong URI scheme" do
    expect { described_class.new("crypt.readhead:foobar") }.to raise_exception(ArgumentError)
  end

  pending "raises if given an unknown URI version"
  pending "raises if given a URI with a malformed authority section"
end
