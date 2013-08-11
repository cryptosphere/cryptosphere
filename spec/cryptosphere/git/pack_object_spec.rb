require 'spec_helper'
require 'cryptosphere/git'

describe Cryptosphere::Git::PackObject do
  let(:stringio) { StringIO.new(fixture('packfile')).set_encoding("ASCII-8BIT") }
  subject { Cryptosphere::Git::PackReader.new(stringio).next_object }

  it "parses correctly" do
    subject.should be_a described_class
    subject.type.should   eq 1
    subject.length.should eq 24
  end

  it "reads its contents" do
    subject.body.should eq "\x9D\vx\x9C\x9D\xCCM\n\xC20\x10@\xE1}N1\x17\xB0L\x9A\xBF\x06\xA4\xE8".force_encoding("ASCII-8BIT")
  end
end