require 'cryptosphere'

require 'cryptosphere/git'
require 'cryptosphere/resources/asset'
require 'cryptosphere/resources/home'

module Cryptosphere
  # Default address of the webapp
  APP_ADDR = "127.0.0.1"

  # Default port of the webapp
  APP_PORT = 7890

  # The Cryptosphere webapp
  App = Webmachine::Application.new do |app|
    app.routes do
      # Git-related routes
      # TODO: factor these elsewhere
      add ['repos', :repo_id, 'info', 'refs'],     Git::Refs
      add ['repos', :repo_id, 'git-receive-pack'], Git::ReceivePack

      # Base web application routes
      add ['assets', '*'], Resources::Asset
      add ['*'], Resources::Home
    end

    app.configure do |config|
      config.ip      = APP_ADDR
      config.port    = APP_PORT
      config.adapter = :Reel
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
      uri      = URI(request.uri)

      # Translate extended HTTP verbs via the magical query parameter
      if request.method == "POST" && request.query['_method']
        method = request.query['_method']
      else
        method = request.method
      end

      Cryptosphere.logger.info "\"%s %s\" %d %.1fms (%s)" % [
        method, uri.path, code, event.duration, resource
      ]
    end
  end

  Webmachine::Events.subscribe('wm.dispatch', RequestLogger.new)
end
