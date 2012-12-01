require 'cryptosphere'
require 'webmachine'
require 'webmachine/adapters/reel'

module Cryptosphere
  # Default address of the webapp
  APP_ADDR = "127.0.0.1"

  # Default port of the webapp
  APP_PORT = 7890

  # Namespace for all Cryptosphere Webmachine Resources
  module Resource; end
  require 'cryptosphere/resources/home'

  # The Cryptosphere webapp
  App = Webmachine::Application.new do |app|
    app.routes do
      # Point all URIs at the MyResource class
      add ['*'], Resource::Home
    end

    app.configure do |config|
      config.ip      = APP_ADDR
      config.port    = APP_PORT
      config.adapter = :Reel
    end
  end
end