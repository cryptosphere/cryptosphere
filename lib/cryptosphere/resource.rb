require 'lattice'

module Cryptosphere
  class Resource < Lattice::Resource
    def finish_request
      response.headers["Content-Security-Policy"] = "default-src 'self'"
      response.headers["X-Content-Type-Options"]  = "nosniff"
      response.headers["X-Frame-Options"]         = "DENY"
    end
  end
end
