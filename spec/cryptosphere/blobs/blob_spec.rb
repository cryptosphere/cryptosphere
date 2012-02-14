require 'spec_helper'

describe Cryptosphere::Blob do
  it "creates blobs from data" do
    builder = Cryptosphere::Blob::Builder.new
    builder << "foobar"
    blob = builder.finish
    blob.decrypt.should == "foobar"
  end
end