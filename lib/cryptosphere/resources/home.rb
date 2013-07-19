require 'cryptosphere/resource'

module Cryptosphere
  module Resources
    class Home < Resource
      def to_html
        # Hax serve a static file!
        File.read File.expand_path("../../assets/index.html", __FILE__)
      end
    end
  end
end