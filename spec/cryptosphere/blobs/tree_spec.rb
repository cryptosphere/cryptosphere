require 'spec_helper'

describe Cryptosphere::Tree do
  it "creates nodes" do
    file = Cryptosphere::Blob["file::foobar"]
    foobar = Cryptosphere::Tree::Entry['-', 'file', file.id, file.key, "foobar"]
    tree = Cryptosphere::Tree[foobar]
    tree.to_s.should == "- file #{file.id} #{file.key} foobar"
  end
end