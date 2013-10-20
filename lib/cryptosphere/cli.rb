require 'thor'
require 'cryptosphere'

module Cryptosphere
  class CLI < Thor
    
    desc 'server', 'Run the Cryptosphere server'
    def server
      require 'cryptosphere/app'

      Cryptosphere.logger.info "Starting web UI on http://#{Cryptosphere::APP_ADDR}:#{Cryptosphere::APP_PORT}"
      Cryptosphere::App.run
    end
  end
end