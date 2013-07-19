module Cryptosphere
  # PktLines are self-delimiting strings, modeled after Git's pkt-lines. Most
  # of the Git protocol is described around pkt-lines. The Cryptosphere
  # adopts this standard as well.
  #
  # A PLine is a variable length binary string. The first four bytes of the
  # PLine, interpreted as hexadecimal digits, indicate its own length,
  # including the 4-byte length prefix.
  #
  # pkt-lines are specified in git's own documentation. See:
  #
  #     Documentation/technical/protocol-common.txt
  #
  module PktLine
    # Maximum length as dictated by the pkt-line standard
    PKT_LEN_MAX = 65_524

    # The length prefix specifies a data segment longer than PKT_LEN_MAX
    class InvalidLength < ArgumentError; end

    # Parse a PktLine from a String. Since PktLines are self-delimiting,
    # any remaining data beyond what the PktLine includes is returned
    # for further processing
    #
    # @param [String] string to be parsed
    # @return [Array<(String,String)>, nil] parsed string + remaining data
    def self.parse(string)
      # Obtain the "pkt-len"
      prefix = string[/^[0-9a-f]{4}/]
      return unless prefix

      length = Integer("0x#{prefix}")

      if length > PKT_LEN_MAX
        raise InvalidLength, "length prefix too long"
      elsif length >= 4
        return if string.length < length

        data = string[4, length - 4]
        remaining = string[length..-1]

        [data, remaining]
      elsif length.zero?
        return [nil, string[4..-1]]
      else
        raise InvalidLength, "length prefix is malformed"
      end
    end
  end
end