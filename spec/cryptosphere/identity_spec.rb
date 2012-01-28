require 'spec_helper'

describe Cryptosphere::Identity do
  it "generates identities" do
    Cryptosphere::Identity.generate.should be_a Cryptosphere::Identity
  end
end