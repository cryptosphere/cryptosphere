module Cryptosphere
   # Maximum length as dictated by the pkt-line standard
  PKT_LINE_MAX = 65_524

  # pkt-lines are self-delimiting strings, modeled after the Git construct.
  # Git's protocol is largely described around pkt-lines. The Cryptosphere
  # adopts this standard as well.
  #
  # The first four bytes of the, interpreted as hexadecimal digits, indicate
  # its length, 4-byte length prefix included.
  #
  # pkt-lines are specified in git's own documentation. See:
  #
  #     Documentation/technical/protocol-common.txt
  #
  class PktLineReader
    # Return a reader which will parse successive pkt-lines
    #
    # @param [#read] input IO-alike that responds to #read
    # @return [PktLineReader] a new PktLineReader for this IO
    def initialize(input)
      @input = input
    end

    # Read a pkt-line from the input source
    #
    # @return [String, nil] parsed pkt-line, or nil for flush-pkts
    def read
      # Obtain the "pkt-len"
      prefix = @input.read(4)
      raise ProtocolError, "invalid pkt-line prefix: #{prefix}" unless prefix[/^[0-9a-f]{4}/]

      length = Integer(prefix, 16)
      return nil if length.zero?
      raise LengthError, "length prefix too long" if length > PKT_LINE_MAX
      raise LengthError, "length prefix is malformed" if length < 4

      @input.read(length - 4) || ""
    end
  end
end