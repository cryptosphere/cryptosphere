require 'spec_helper'
require 'cryptosphere/git'

describe Cryptosphere::Git::Refs do
  include Webmachine::Test

  let(:app) { Cryptosphere::App }
  let(:example_repo) { "/repos/example.git" }

  it "serves an empty list of refs" do
    get "#{example_repo}/info/refs?service=git-receive-pack"

    response.code.should eq 200
    response.headers['Content-Type'].should eq "application/x-git-receive-pack-advertisement"

    # TODO: parse response, determine validity
    response.body.should match(/^001f# service=git-receive-pack/)
  end
end