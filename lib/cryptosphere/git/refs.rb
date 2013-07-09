require 'webmachine'
require 'zlib'
require 'stringio'

module Cryptosphere
  module Git
    class Refs < Webmachine::Resource
      # Pack data header for the HTTP-based git-receive-pack service
      # TODO: roll this up with some other related code somewhere
      SERVICE_HEADER = "001f# service=git-receive-pack"

      def encodings_provided
        {
          'gzip'     => :encode_gzip,
          'identity' => :encode_identity
        }
      end

      def content_types_provided
        [['application/x-git-receive-pack-advertisement', :to_bytes]]
      end

      def resource_exists?
        # TODO: check actual git repo name
        # For now only example.git will work
        return false unless request.path_info[:repo_id] == 'example.git'

        # Ensure the client is speaking the git protocol
        return false unless request.query['service'] == 'git-receive-pack'

        true
      end

      def to_bytes
        response = []
        response << SERVICE_HEADER

        # TODO: this hardcodes an empty repository. Eventually we should
        # support more than just empty repositories.
        response << [
          "000000880000000000000000000000000000000000000000",
          "capabilities^{}\0",
          "report-status",
          "delete-refs",
          "side-band-64k",
          "quiet",
          "ofs-delta",
          "agent=git/1.8.1.6"
        ].join(' ')

        response << "0000"
        response.join("\n")
      end
    end
  end
end