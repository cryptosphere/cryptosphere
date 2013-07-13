require 'celluloid'
require 'webmachine'
require 'active_support/core_ext/class/attribute'

module Cryptosphere
  class Resource < Webmachine::Resource
    include Celluloid::Logger

    class_attribute :content_types_accepted
    class_attribute :content_types_provided
    class_attribute :encodings_provided

    class << self
      def accept_content_type(content_types)
        content_types.each do |key, value|
          self.content_types_accepted ||= []
          content_types_accepted << [key, value]
        end
      end
      alias accept accept_content_type

      def provide_content_type(content_types)
        content_types.each do |key, value|
          self.content_types_provided ||= []
          content_types_provided << [key, value]
        end
      end

      def provide_encoding(encodings)
        encodings.each do |key, value|
          self.encodings_provided ||= {}
          encodings_provided[key] = value
        end
      end
    end

    def handle_exception(ex)
      crash "Exception rendering #{self.class}!", ex
    end
  end
end