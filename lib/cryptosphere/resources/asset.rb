require 'cryptosphere/resource'

module Cryptosphere
  module Resources
    class Asset < Resource
      ASSET_ROOT = File.expand_path("../../assets", __FILE__)
      FILE_LIST  = Dir[File.join(ASSET_ROOT, "**", "*")].map { |f| f.sub(/^#{ASSET_ROOT}\//, '') }

      def resource_exists?
        FILE_LIST.include? asset_path
      end

      def content_types_provided
        return [["text/html", nil]] if request.path_tokens.empty?
        extension = request.path_tokens.last[/\.([a-z0-9]+)$/, 1]

        case extension
        when 'htm', 'html'
          [["text/html", :produce_file]]
        when 'css'
          [["text/css", :produce_file]]
        when 'js'
          [["text/javascript", :produce_file]]
        when 'png'
          [["image/png", :produce_file]]
        else
          [["text/html", nil]]
        end
      end

      def produce_file
        Pathname.new(ASSET_ROOT).join(asset_path).read
      end

      def asset_path
        request.path_tokens.join("/")
      end
    end
  end
end