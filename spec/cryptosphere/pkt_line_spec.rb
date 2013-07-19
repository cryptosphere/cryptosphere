require 'spec_helper'

describe Cryptosphere::PktLine do
  it "parses git's test vectors" do
    described_class.parse("0006a\n").should eq ["a\n", ""]
    described_class.parse("0005a").should eq ["a", ""]
    described_class.parse("000bfoobar\n").should eq ["foobar\n", ""]
    described_class.parse("0004").should eq ["", ""]
  end

  it "parses flush-pkts as nil" do
    described_class.parse("0000").should eq [nil, ""]
  end

  it "returns the trailing portions of strings" do
    described_class.parse("0005afoobar").should eq ["a", "foobar"]
  end

  it "returns nil if more data is needed to parse the length prefix" do
    described_class.parse("").should be_nil
    described_class.parse("0").should be_nil
    described_class.parse("00").should be_nil
    described_class.parse("000").should be_nil
  end

  it "returns nil if more data is needed to parse the string" do
    described_class.parse("0005").should be_nil
    described_class.parse("0006a").should be_nil
  end
end