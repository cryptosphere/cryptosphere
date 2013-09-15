require 'spec_helper'

describe Cryptosphere::PktLineReader do
  it "reads git's test vectors" do
    described_class.new(StringIO.new("0006a\n")).read.should eq "a\n"
    described_class.new(StringIO.new("0005a")).read.should eq "a"
    described_class.new(StringIO.new("000bfoobar\n")).read.should eq "foobar\n"
    described_class.new(StringIO.new("0004")).read.should eq ""
  end

  it "reads flush-pkts as nil" do
    described_class.new(StringIO.new("0000")).read.should be_nil
  end

  it "raises LengthError for overly long strings" do
    expect do
      described_class.new(StringIO.new("fff5" + "A" * 65525)).read
    end.to raise_exception(Cryptosphere::LengthError)
  end
end