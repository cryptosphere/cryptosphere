require 'spec_helper'

describe Cryptosphere::Bucket do
  it "generates new buckets" do
    Cryptosphere::Bucket.generate.should be_a Cryptosphere::Bucket
  end
end