require 'spec_helper'
require 'cryptosphere/git'

describe Cryptosphere::Git::ReceivePack do
  include Webmachine::Test

  let(:app) { Cryptosphere::App }
  let(:example_repo) { "/repos/example.git" }

  EXAMPLE_PACK = "00a60000000000000000000000000000000000000000 513d7cc8d1af637ed410243494041d007dbae0e8 refs/heads/master\0 report-status side-band-64k agent=git/1.7.12.4.(Apple.Git-37)0000PACK\0\0\0\x02\0\0\0\x03\x9D\vx\x9C\x9D\xCCM\n\xC20\x10@\xE1}N1\x17\xB0L\x9A\xBF\x06\xA4\xE8\xD2\xBD\x17\x98&\xA9\x0E4\r\x84q\xE1\xED-\xF4\x06.\xBF\xB7x\xD2K\x81\x80K\xF2.\xE2\xE8\x93v\x99rv\xCB\x14W\xAB1\xF9\x123\xC5\x95(X\x9C\xBC\xA2\x8F\xBC[\x87g\xDB\xBFp\xEF\x89Kg\xB8\xCA\xA1\x81N\xDD^\x95x\eR\xAB3h\x13\xCChl\xD4\x0E.\x18\x10\xD5Q+\x8B\x94\xBF\a\xEA\xB1\xB30mp\x9E\xD4\x0F\xFC\xFF;\x1A\xA5\x02x\x9C340031Q\brut\xF1u\xD5\xCBMaX,~\xFD\xEF\xD6\x9AOJ\rn\xA7\xA6\xCF{\xDD\x91\x15V)<\x1F\0\xEC\x03\x0E\xF3;x\x9C\xF3\xF1\xF7Q(JML\xC9M\xE5\x02\0\x15\x1D\x03\x80*'\xE6\xB89\x15\x9E0\x15\xB4W\x87\xE8\x90d\xE1\xA7\x83\xA3\x03"

  it "accepts packs" do
    header "Content-Type", "application/x-git-receive-pack-request"
    body EXAMPLE_PACK
    post "#{example_repo}/git-receive-pack"

    response.code.should eq 201
    response.headers['Content-Type'].should eq "application/x-git-receive-pack-result"
  end
end