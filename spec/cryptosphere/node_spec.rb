require 'spec_helper'

describe Cryptosphere::NodeBuilder do
  it "creates nodes from data" do
    builder = Cryptosphere::NodeBuilder.new
    builder << "foobar"
    node = builder.finish
    node.decrypt.should == "foobar"
  end
end