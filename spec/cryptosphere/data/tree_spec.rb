require 'spec_helper'

describe Cryptosphere::Tree do
  it "creates nodes" do
    blob = Cryptosphere::Node["blob foobar"]
    foobar = Cryptosphere::Tree::Entry['-', 'blob', blob.id, blob.key, "foobar"]
    tree = Cryptosphere::Tree[foobar]
    tree.to_s.should == "- blob #{blob.id} #{blob.key} foobar"
  end
end