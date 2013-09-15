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
      SIZE_PREFIX_LIMIT = 9

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
        @object_length = nil
      end

      # Read the next object from the pack
      #
      # @return [Cryptosphere::Git::PackObject] streamable pack object
      def next_object
        unless @state == :object_header
          raise StateError, "not ready to read a new object"
        end

        fill_buffer(1)
        size_prefix_bytes = 1

        byte  = @buffer.bytes[0].ord
        size  = byte & 0xf
        type  = (byte >> 4) & 7
        shift = 4

        while byte & 0x80 != 0
          raise FormatError, "object header too long" if size_prefix_bytes >= SIZE_PREFIX_LIMIT

          size_prefix_bytes += 1
          fill_buffer(size_prefix_bytes)
          byte = @buffer.bytes[size_prefix_bytes - 1].ord
          size |= ((byte & 0x7f) << shift)
          shift += 7
        end

        # Discard the length prefix
        @buffer.slice!(0, size_prefix_bytes)

        @state = :object_body
        @object_remaining = size

        PackObject.new(self, type, size)
      end

      # Read raw data from a pack object if we're in the correct state
      #
      # @raise [Cryptosphere::StateError] not inside a packed object's body
      #
      # @return [Cryptosphere::Git::PackObject] streamable pack object
      def readpartial(length = nil)
        raise StateError, "not reading object body" if @state != :object_body

        length ||= @object_remaining

        if @buffer && !@buffer.empty?
          if length < @buffer.length
            @object_remaining -= length
            buffer = @buffer.slice!(0, length)
          else
            buffer = @buffer
            @buffer = ""
            @object_remaining -= buffer.length
          end
        else
          buffer = @input.readpartial(length)
          @object_remaining -= buffer.length
        end

        @state = :object_header if @object_remaining == 0
        buffer
      end

      # Ensure the buffer contains at least the given amount of input
      #
      # @param [Fixnum] size of buffer when finished
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