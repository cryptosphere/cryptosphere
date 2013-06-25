require 'spec_helper'

describe Cryptosphere::Head::WriteHead do
  subject { described_class.generate("foobar") }

  let(:read_head) { subject.read_head }
  let(:example_uri) { "crypt:221B+Baker+Street" }

  it "moves heads" do
    position = subject.set_uri(example_uri)
    message  = position.to_s

    new_position = read_head.read(message)
    new_position.uri.should eq example_uri
  end

  pending "raises if given the wrong URI scheme"
end
