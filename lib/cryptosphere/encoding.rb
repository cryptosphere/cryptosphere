require 'base32'

module Cryptosphere
  # Base32 content encoding provider. Used for all Cryptosphere URIs
  # Uses a tweaked Base32 derivative, where lower case characters are
  # used ubiquitously and no padding characters are added, similar to
  # z-base-32 but with all possible characters present.
  module Encoding
    module_function

    # Encode a string in Cryptosphere-style Base32
    #
    # @param string [String] arbitrary string to be encoded
    # @return [String] lovely, elegant Cryptosphere-style Base32
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