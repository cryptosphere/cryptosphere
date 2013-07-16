require 'celluloid'
require 'webmachine'
require 'active_support/core_ext/class/attribute'

module Cryptosphere
  class Resource < Webmachine::Resource
    include Celluloid::Logger

    class_attribute :allowed_methods
    class_attribute :content_types_accepted
    class_attribute :content_types_provided
    class_attribute :encodings_provided

    class << self
      def allow_method(*methods)
        self.allowed_methods ||= []
        self.allowed_methods += methods.map(&:to_s).map(&:upcase)
      end
      alias allow allow_method

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
        self.encodings_provided ||= {}
        encodings_provided.merge!(encodings)
      end
    end

    def content_types_accepted
      types = self.class.content_types_accepted
      return types if types && !types.empty?
      super
    end

    def content_types_provided
      types = self.class.content_types_provided
      return types if types && !types.empty?
      super
    end

    def encodings_provided
      encodings = self.class.encodings_provided
      return encodings if encodings && !encodings.empty?
      super
    end

    def handle_exception(ex)
      crash "Exception rendering #{self.class}!", ex
    end
  end
end