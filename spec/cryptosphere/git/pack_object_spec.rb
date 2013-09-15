require 'spec_helper'
require 'cryptosphere/git'

describe Cryptosphere::Git::PackObject do
  let(:stringio) { StringIO.new(fixture('packfile')).set_encoding("ASCII-8BIT") }

  let(:example_commit) do
<<COMMIT
tree 70bc659026c15dadd5b89f410c6e9da9faa74086
author Tony Arcieri <tony.arcieri@gmail.com> 1373234915 -0700
committer Tony Arcieri <tony.arcieri@gmail.com> 1373234915 -0700

Initial commit
COMMIT
  end

  subject { Cryptosphere::Git::PackReader.new(stringio).next_object }

  it "parses correctly" do
    subject.should be_a described_class
    subject.type.should   eq 1
    subject.length.should eq 189
  end

  it "reads its contents" do
    example_commit.force_encoding("ASCII-8BIT")
    subject.body.should eq example_commit
  end
end