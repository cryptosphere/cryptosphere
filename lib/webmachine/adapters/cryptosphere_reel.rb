require 'reel'
require 'webmachine/version'
require 'webmachine/headers'
require 'webmachine/request'
require 'webmachine/response'
require 'webmachine/dispatcher'
require 'set'

module Webmachine
  module Adapters
    # A enhanced Reel adapter with some tweaks necessary to make the
    # Cryptosphere work. Perhaps this version can get incorporated upstream
    class CryptosphereReel < Adapter
      def run
        @options = {
          :port => configuration.port,
          :host => configuration.ip
        }.merge(configuration.adapter_options)

        if extra_verbs = configuration.adapter_options[:extra_verbs]
          @extra_verbs = Set.new(extra_verbs.map(&:to_s).map(&:upcase))
        else
          @extra_verbs = Set.new
        end

        server = ::Reel::Server.supervise(@options[:host], @options[:port], &method(:process))

        # FIXME: this will no longer work on Ruby 2.0. We need Celluloid.trap
        trap("INT") { server.terminate; exit 0 }
        Celluloid::Actor.join(server)
      end

      def process(connection)
        while request = connection.request
          # Users of the adapter can configure a custom WebSocket handler
          if request.is_a? ::Reel::WebSocket
            if handler = @options[:websocket_handler]
              handler.call(request)
            else
              # Pretend we don't know anything about the WebSocket protocol
              # FIXME: This isn't strictly what RFC 6455 would have us do
              request.respond :bad_request, "WebSockets not supported"
            end

            next
          end

          # Optional support for e.g. WebDAV verbs not included in Webmachine's
          # state machine. Do the "Railsy" thing and handle them like POSTs
          # with a magical parameter
          if @extra_verbs.include?(request.method)
            method = "POST"
            param  = "_method=#{request.method}"
            uri    = request_uri(request.url, request.headers, param)
          else
            method = request.method
            uri    = request_uri(request.url, request.headers)
          end

          wm_headers  = Webmachine::Headers[request.headers.dup]
          wm_request  = Webmachine::Request.new(method, uri, wm_headers, request.body)
          wm_response = Webmachine::Response.new
          @dispatcher.dispatch(wm_request, wm_response)

          request.respond ::Reel::Response.new(wm_response.code, wm_response.headers, wm_response.body)
        end
      end

      def request_uri(path, headers, extra_query_params = nil)
        host_parts = headers.fetch('Host').split(':')
        path_parts = path.split('?')

        uri_hash = {host: host_parts.first, path: path_parts.first}

        uri_hash[:port]  = host_parts.last.to_i if host_parts.length == 2
        uri_hash[:query] = path_parts.last      if path_parts.length == 2

        if extra_query_params
          if uri_hash[:query]
            uri_hash[:query] << "&#{extra_query_params}"
          else
            uri_hash[:query] = extra_query_params
          end
        end

        URI::HTTP.build(uri_hash)
      end
    end
  end
end