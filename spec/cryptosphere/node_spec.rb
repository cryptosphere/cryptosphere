require 'spec_helper'

describe Cryptosphere::Node do
  it "creates nodes from data" do
    builder = Cryptosphere::Node::Builder.new
    builder << "foobar"
    node = builder.finish
    node.decrypt.should == "foobar"
  end
end