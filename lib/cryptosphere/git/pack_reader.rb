module Cryptosphere
  module Git
    # Packs are Git's structuring mechanism for collections of objects. They
    # are described in Git's documentation under:
    #
    #     Documentation/technical/pack-format.txt
    #
    # PackReader implements a streaming reader for Git's pack format, used to
    # decode and process incoming packs on-the-fly.
    class PackReader
      PACK_SIGNATURE = "PACK"

      # Sanity limit on object header size. This provides 60-bits of length,
      # or 1 exabyte of data. It is considered sufficient for today's purposes
      HEADER_SANITY_LIMIT = 9

      # Return a pack reader that will parse successive objects in a purely
      # streaming manner, allowing packs to be streamed off the network.
      #
      # @param [#read] input IO-alike that responds to #read
      # @return [PackReader] a new PktLineReader for this IO
      def initialize(input)
        header = input.read(12)
        raise FormatError, "premature end of git pack" unless header

        signature, version, total_objects = header.unpack("a4N2")

        raise FormatError, "git pack does not start with #{PACK_SIGNATURE}" unless signature == PACK_SIGNATURE
        raise FormatError, "unsupported git pack version: #{version}" unless version == 2

        @input = input
        @total_objects = @remaining_objects = total_objects
        @buffer = ""
      end

      # Read the next object from the pack
      #
      # @return [Cryptosphere::Git::PackObject] streamable pack object
      def next_object
        begin
          fill_buffer
        rescue EOFError
          raise FormatError, "couldn't parse object header" 
        end

        byte = @buffer[0].ord

        more   = byte >> 7 & 0x1
        type   = byte >> 4 & 0x7
        length = byte & 0xf

        consumed = 1

        while more == 1
          raise FormatError, "object header too long" if consumed >= HEADER_SANITY_LIMIT

          if consumed >= @buffer.length
            begin
              fill_buffer
            rescue EOFError
              raise FormatError, "couldn't parse object header" 
            end
          end

          byte   = @buffer[consumed].ord
          more   = byte >> 7 & 0x1
          length += byte & 0x7f

          consumed += 1
        end

        PackObject.new(self, type, length)
      end

    private

      # Add some data to the buffer from the input
      #
      # @return [String] newly filled buffer
      def fill_buffer
        chunk = @input.readpartial
        raise EOFError, "end of file encountered" unless chunk && chunk.length > 0
        @buffer << chunk
      end
    end
  end
end