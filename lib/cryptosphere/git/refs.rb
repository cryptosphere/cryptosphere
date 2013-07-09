require 'webmachine'
require 'zlib'
require 'stringio'

module Cryptosphere
  module Git
    class Refs < Webmachine::Resource
      # Packfile header for the HTTP-based git-receive-pack service
      # TODO: roll this up with some other related code somewhere
      SERVICE_HEADER = "001f# service=git-receive-pack"

      def encodings_provided
        # TODO: not working? o_O
        {'gzip' => :encode_gzip}
      end

      def content_types_provided
        [['application/octet-stream', :to_bytes]]
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
          "capabilities^{}",
          "report-status",
          "delete-refs",
          "side-band-64k",
          "quiet",
          "ofs-delta",
          "agent=cryptosphere/#{VERSION}"
        ].join(' ')

        response << "0000"
        gzip response.join("\n")
      end

      # TODO: this shouldn't be necessary, it should be provited by Webmachine
      # but it's not working for whatever reason
      def gzip(string)
        output = StringIO.new

        gz = Zlib::GzipWriter.new(output)
        gz.write string
        gz.close

        output.to_s
      end
    end
  end
end