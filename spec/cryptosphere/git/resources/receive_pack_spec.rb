require 'spec_helper'
require 'cryptosphere/git'
require 'stringio'

describe Cryptosphere::Git::Resources::ReceivePack do
  include Webmachine::Test

  let(:app) { Cryptosphere::App }
  let(:example_repo) { "/repos/example.git" }

  it "accepts packs" do

    header "Content-Type", "application/x-git-receive-pack-request"

    pktline = "00a60000000000000000000000000000000000000000 513d7cc8d1af637ed410243494041d007dbae0e8 refs/heads/master\0 report-status side-band-64k agent=git/1.7.12.4.(Apple.Git-37)0000"
    body StringIO.new(pktline + fixture('packfile')).set_encoding("ASCII-8BIT")
    post "#{example_repo}/git-receive-pack"

    response.code.should eq 201
    response.headers['Content-Type'].should eq "application/x-git-receive-pack-result"
  end
end