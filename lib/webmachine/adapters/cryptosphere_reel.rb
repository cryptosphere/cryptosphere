require 'reel'
require 'webmachine/version'
require 'webmachine/headers'
require 'webmachine/request'
require 'webmachine/response'
require 'webmachine/dispatcher'
require 'webmachine/chunked_body'
require 'set'

module Webmachine
  module Adapters
    # A enhanced Reel adapter with some tweaks necessary to make the
    # Cryptosphere work. Perhaps this version can get incorporated upstream
    class CryptosphereReel < Adapter
      # Nonstandard HTTP verbs (i.e. WebDAV) not understood by Webmachine's
      # state machine, to translate to a POST request with the actual verb
      # passed via the magical _method param ala Rails
      EXTENDED_VERBS = Set.new([:propfind, :proppatch, :mkcol, :copy, :move, :lock, :unlock])

      def run
        options = {
          :port => configuration.port,
          :host => configuration.ip
        }.merge(configuration.adapter_options)

        server = ::Reel::Server.supervise(options[:host], options[:port], &method(:process))
        trap("INT"){ server.terminate; exit 0 }
        sleep
      end

      def process(connection)
        while reel_request = connection.request
          # Users of the adapter can configure a custom WebSocket handler
          if reel_request.is_a? ::Reel::WebSocket
            handler = configuration.adapter_options[:websocket_handler]
            handler.call(wreq) if handler
            next
          end

          # Translate WebDAV verbs into POST requests with a _method param
          if EXTENDED_VERBS.include?(reel_request.method)
            method = "POST"
            param  = "_method=#{request_method(reel_request)}"
            uri    = request_uri(reel_request.url, reel_request.headers, param)
          else
            method = request_method(reel_request)
            uri    = request_uri(reel_request.url, reel_request.headers)
          end

          headers = Webmachine::Headers[reel_request.headers.dup]
          body    = LazyRequestBody.new(reel_request)

          request  = Webmachine::Request.new(method, uri, headers, body)
          response = Webmachine::Response.new
          @dispatcher.dispatch(request, response)

          connection.respond ::Reel::Response.new(response.code, response.headers, response.body)
        end
      end

      def request_method(request)
        request.method.to_s.upcase
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