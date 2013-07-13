require 'spec_helper'
require 'cryptosphere/resource'

describe Cryptosphere::Resource do
  context "acceptable content types" do
    it "can be declared with `accept_content_type'" do
      klass = Class.new(described_class) do
        accept_content_type "application/json" => :to_json
        accept_content_type "text/xml" => :to_xml
      end

      klass.content_types_accepted.should eq [
        ["application/json", :to_json],
        ["text/xml", :to_xml]
      ]
    end

    it "can be declared with `accept'" do
      klass = Class.new(described_class) do
        accept "application/json" => :to_json
        accept "text/xml" => :to_xml
      end

      klass.content_types_accepted.should eq [
        ["application/json", :to_json],
        ["text/xml", :to_xml]
      ]
    end
  end

  context "provided content types" do
    it "can be declared with `provide_content_type'" do
      klass = Class.new(described_class) do
        provide_content_type "application/json" => :to_json
        provide_content_type "text/xml" => :to_xml
      end

      klass.content_types_provided.should eq [
        ["application/json", :to_json],
        ["text/xml", :to_xml]
      ]
    end
  end

  context "provided encodings" do
    it "can be declared with `provide_encoding'" do
      klass = Class.new(described_class) do
        provide_encoding 'gzip' => :encode_gzip
        provide_encoding 'identity' => :encode_identity
      end

      klass.encodings_provided.should eq({
        'gzip'     => :encode_gzip,
        'identity' => :encode_identity
      })
    end
  end
end