require 'spec_helper'
require 'cryptosphere/git'
require 'stringio'

describe Cryptosphere::Git::PackReader do
  let(:stringio) { StringIO.new(fixture('packfile')).set_encoding("ASCII-8BIT") }
  subject { described_class.new(stringio) }

  it "returns the next object in the pack" do
    obj = subject.next_object
    obj.should be_a Cryptosphere::Git::PackObject
    obj.type.should   eq 1
    obj.length.should eq 189
  end

  it "raises FormatError if fed garbage" do
    expect { described_class.new(StringIO.new("")) }.to raise_exception Cryptosphere::FormatError
    expect { described_class.new(StringIO.new("\0" * 128)) }.to raise_exception Cryptosphere::FormatError
  end
end