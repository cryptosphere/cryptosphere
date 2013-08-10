module Cryptosphere
  module Git
    # Pack objects represent data within Git. They are described in Git's
    # documentation under:
    #
    #     Documentation/technical/pack-format.txt
    #
    class PackObject
      # Sanity limit on object header size. This provides 60-bits of length,
      # or 1 exabyte of data. It is considered sufficient for today's purposes
      HEADER_SANITY_LIMIT = 9

      # Parse the header of a packed object, returning a streamable PackObject
      # or nil if more data is needed to parse the object
      #
      # @param [String] buffer to be processed
      # @return [PackObject, nil] PackObject or nil if more data is needed
      def self.parse_header(buffer)
        byte     = buffer[0].ord
        consumed = 1

        more   = byte >> 7 & 0x1
        type   = byte >> 4 & 0x7
        length = byte & 0xf

        while more == 1
          raise FormatError, "object header too long" if consumed >= HEADER_SANITY_LIMIT

          # Need more data
          return nil if consumed >= buffer.length

          byte   = buffer[consumed].ord
          more   = byte >> 7 & 0x1
          length += byte & 0x7f

          consumed += 1
        end

        new(type, length, buffer)
      end

      attr_reader :type, :length

      # Create a new streamable pack object
      #
      # @param [Fixnum] type of git pack object
      # @param [Fixnum] length of pack object
      # @return [PackObject] a new PackObject ready to stream
      def initialize(type, length, buffer = "")
        @type   = type
        @length = length
        @buffer = buffer
      end
    end
  end
end