require 'spec_helper'
require 'cryptosphere/git'

describe Cryptosphere::Git::ReceivePack do
  include Webmachine::Test

  let(:app) { Cryptosphere::App }
  let(:example_repo) { "/repos/example.git" }

  it "accepts packs" do
    header "Content-Type", "application/x-git-receive-pack-request"
    body fixture('packfile')
    post "#{example_repo}/git-receive-pack"

    response.code.should eq 201
    response.headers['Content-Type'].should eq "application/x-git-receive-pack-result"
  end
end