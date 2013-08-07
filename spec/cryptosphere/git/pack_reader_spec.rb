require 'spec_helper'
require 'cryptosphere/git'
require 'stringio'

describe Cryptosphere::Git::PackReader do
  subject { described_class.new(StringIO.new(fixture('packfile'))) }

  it "returns the next object in the pack" do
    obj = subject.next_object
    obj.should be_a Cryptosphere::Git::PackObject
    obj.type.should   eq 1
    obj.length.should eq 24
  end

  it "raises FormatError if fed garbage" do
    expect { described_class.new(StringIO.new("")) }.to raise_exception Cryptosphere::FormatError
    expect { described_class.new(StringIO.new("\0" * 128)) }.to raise_exception Cryptosphere::FormatError
  end
end