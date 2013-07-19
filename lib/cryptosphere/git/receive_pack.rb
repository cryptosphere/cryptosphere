require 'cryptosphere/resource'
require 'cryptosphere/pkt_line'

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
        # TODO: streaming support!
        remaining = request.body.to_s

        # TODO: WTF encoding??? :(
        remaining.force_encoding('ASCII-8BIT')

        if result = PktLine.parse(remaining)
          data, remaining = result
        else
          warn "accept_pack couldn't parse pkt-line!"
          return false
        end

        #p data

        flush, remaining = PktLine.parse(remaining)
        if !flush.nil? || remaining.nil?
          warn "accept_pack coldn't parse flush packet"
          return false
        end

        #p remaining
        true
      end
    end
  end
end