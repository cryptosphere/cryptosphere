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
    expect(subject).to be_a described_class
    expect(subject.type).to eq :commit
    expect(subject.length).to eq 189
    expect(subject.body.length).to eq subject.length
    expect(subject.sha1_hexdigest).to eq "513d7cc8d1af637ed410243494041d007dbae0e8"
  end

  it "reads its contents" do
    example_commit.force_encoding("ASCII-8BIT")
    subject.body.should eq example_commit
  end
end