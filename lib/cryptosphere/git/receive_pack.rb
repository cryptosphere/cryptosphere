require 'cryptosphere/resource'
require 'cryptosphere/pkt_line_reader'

module Cryptosphere
  module Git
    class ReceivePack < Resource
      allow :get, :head, :post, :options

      accept_content_type  'application/x-git-receive-pack-request' => :accept_pack
      provide_content_type 'application/x-git-receive-pack-result'  => :to_result

      provide_encoding 'gzip'     => :encode_gzip
      provide_encoding 'identity' => :encode_identity

      def resource_exists?
        # TODO: check actual git repo name
        # For now only example.git will work
        return false unless request.path_info[:repo_id] == 'example.git'
        true
      end

      def post_is_create?; true; end
      def create_path
        URI.join(request.base_uri.to_s, "/repos/")
      end

      def accept_pack
        pl_reader = PktLineReader.new(request.body)
        header = pl_reader.read
        raise ProtocolError, "no flush-pkt in header" unless pl_reader.read.nil?

        puts "Header: #{header.inspect}"

        pk_reader = PackReader.new(request.body)
        p pk_reader.next_object
      end
    end
  end
end