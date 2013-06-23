require 'base32'

module Cryptosphere
  # Base32 content encoding provider. Used for all Cryptosphere URIs
  # Uses a tweaked "Zooko-style" Base32 derivative, where lower case
  # characters are used ubiquitously
  module Encoding
    module_function

    # Encode a string in Zooko-style Base32
    #
    # @param string [String] arbitrary string to be encoded
    # @return [String] lovely, elegant "Zooko-style" Base32
    def encode(string)
      Base32.encode(string).downcase.sub(/=+$/, '')
    end

    # Decode a Base32 string
    #
    # @param string [String] Base32 string to be decoded
    # @return [String] decoded string
    def decode(string)
      Base32.decode(string.upcase)
    end
  end
end