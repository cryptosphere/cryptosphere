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
      include Enumerable

      # How we identify we're at the beginning of a pack file
      PACK_SIGNATURE = "PACK"

      # Sanity limit on object header size. This provides 60-bits of length,
      # or 1 exabyte of data. It is considered sufficient for today's purposes
      LENGTH_PREFIX_LIMIT = 9

      # How much data to try to work on at a time in the buffer
      BUFFER_SIZE = 16384

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
        @state  = :object_header
      end

      # Read the next object from the pack
      #
      # @return [Cryptosphere::Git::PackObject] streamable pack object
      def next_object
        unless @state == :object_header
          raise StateError, "not ready to read a new object (in #{@state.inspect} state)"
        end

        fill_buffer(1)
        length_prefix_bytes = 1

        byte   = @buffer.bytes.first.ord
        length = byte & 0xf
        type   = (byte >> 4) & 7
        shift  = 4

        while byte & 0x80 != 0
          raise FormatError, "object header too long" if length_prefix_bytes >= LENGTH_PREFIX_LIMIT

          length_prefix_bytes += 1
          fill_buffer(length_prefix_bytes)
          byte = @buffer.bytes.to_a[length_prefix_bytes - 1].ord
          length |= ((byte & 0x7f) << shift)
          shift += 7
        end

        # Discard the length prefix
        @buffer.slice!(0, length_prefix_bytes)
        @state = :object_body if length > 0

        PackObject.new(self, type, length)
      end

      # Iterate through all of the objects in the pack
      #
      # @return [nil]
      def each
        while @remaining_objects > 0
          yield next_object
        end
      end

      # Read compressed data from a pack object if we're in the correct state
      #
      # @raise [Cryptosphere::StateError] not inside a packed object's body
      #
      # @return [String] compressed pack object data
      def readpartial(length = nil)
        raise StateError, "not reading object body" if @state != :object_body
        length ||= BUFFER_SIZE

        if @buffer && !@buffer.empty?
          if length < @buffer.length
            @object_remaining -= length
            @buffer.slice!(0, length)
          else
            buffer = @buffer
            @buffer = ""
            buffer
          end
        else
          @input.readpartial(length)
        end
      end

      # Inform the reader we've finished reading a pack object, and return any
      # unprocessed data back to the buffer
      # 
      # @param [String] data we'd like to return to the pack reader's buffer
      #
      # @return [nil]
      def finish_object(remaining_data)
        @buffer.prepend(remaining_data) if remaining_data
        @remaining_objects -= 1
        if @remaining_objects > 0
          @state = :object_header
        else
          @state = :eof
        end
      end

      # Ensure the buffer contains at least the given amount of input
      #
      # @param [Fixnum] size of buffer when finished
      #
      # @return [String] newly filled buffer
      def fill_buffer(size = nil)
        return if size.nil? && !buffer.empty?
        to_read = size - @buffer.size
        return if to_read < 1

        begin
          chunk = @input.readpartial
          raise EOFError, "end of file encountered" unless chunk && chunk.length > 0
          @buffer << chunk
        end until size && @buffer.size >= size
      end
      private :fill_buffer
    end
  end
end