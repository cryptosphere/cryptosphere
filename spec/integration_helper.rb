require 'spec_helper'
require 'cryptosphere/app'

def visit(path)
  app = Cryptosphere::App

  verb    = "GET"
  path    = path[0] == "/" ? path : "/#{path}"
  uri     = URI.parse("http://#{app.configuration.ip}:#{app.configuration.port}#{path}")
  headers = Webmachine::Headers["accept" => "*/*"]
  body    = ""

  request  = Webmachine::Request.new(verb, uri, headers, body)
  response = Webmachine::Response.new

  app.dispatcher.dispatch(request, response)
  response
end