require 'cryptosphere'
require 'cryptosphere/git'

require 'webmachine'
require 'webmachine/adapters/cryptosphere_reel'

module Cryptosphere
  # Default address of the webapp
  APP_ADDR = "127.0.0.1"

  # Default port of the webapp
  APP_PORT = 7890

  # Namespace for all Cryptosphere Webmachine Resources
  module Resource; end

  require 'cryptosphere/resources/asset'
  require 'cryptosphere/resources/home'

  # The Cryptosphere webapp
  App = Webmachine::Application.new do |app|
    app.routes do
      # Git-related routes
      # TODO: factor these elsewhere
      add ['repos', :repo_id, 'info', 'refs'], Git::Refs

      # Base web application routes
      add ['assets', '*'], Resource::Asset
      add ['*'], Resource::Home
    end

    app.configure do |config|
      config.ip      = APP_ADDR
      config.port    = APP_PORT
      config.adapter = :CryptosphereReel
    end
  end

  class RequestLogger
    def call(*args)
      handle_event(Webmachine::Events::InstrumentedEvent.new(*args))
    end

    def handle_event(event)
      request  = event.payload[:request]
      resource = event.payload[:resource]
      code     = event.payload[:code]

      # Translate extended HTTP verbs via the magical query parameter
      if request.method == "POST" && request.query['_method']
        method = request.query['_method']
      else
        method = request.method
      end

      Cryptosphere.logger.info "[%s] %s (code=%d resource=%s time=%.1f ms)" % [
        method, request.uri, code, resource, event.duration
      ]
    end
  end

  Webmachine::Events.subscribe('wm.dispatch', RequestLogger.new)
end