require 'spec_helper'

describe Cryptosphere::WriteHead do
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

describe Cryptosphere::ReadHead do
  pending "raises if given the wrong URI scheme"
  pending "identifies stale data"
  pending "identifies data with timestamps in the future"
  pending "identifies positions with invalid signatures"
end
