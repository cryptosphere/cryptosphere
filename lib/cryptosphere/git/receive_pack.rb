require 'cryptosphere/pkt_line_reader'

module Cryptosphere
  module Git
    class ReceivePack < Lattice::Resource
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
        line_reader = PktLineReader.new(request.body)
        header = line_reader.read
        if header
          raise ProtocolError, "no flush-pkt in header" unless line_reader.read.nil?
          debug "Header: #{header.inspect}"
        else
          debug "Huh, no receive pack header, just a flush-pkt?"
        end

        PackReader.new(request.body).each do |pack_object|
          body = pack_object.body
          debug "*** Got a type-#{pack_object.type} object (length #{pack_object.length} [#{pack_object.length}])\n#{body}"
        end
      end
    end
  end
end
