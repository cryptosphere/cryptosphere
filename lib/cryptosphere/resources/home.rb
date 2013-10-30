require 'cryptosphere/resources/asset'

module Cryptosphere
  module Resources
    class Home < Cryptosphere::Resource
      def to_html
        # Hax serve a static file!
        File.read File.join(Asset::ROOT_DIR, "index.html")
      end
    end
  end
end
