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
      end

      # Read the next object from the pack
      #
      # @return [Cryptosphere::Git::PackObject] streamable pack object
      def next_object
        buffer = ""

        begin
          chunk = @input.readpartial
          raise FormatError, "couldn't parse object header" unless chunk && chunk.length > 0

          buffer << chunk
          pack_object = PackObject.parse_header(buffer)
        end until pack_object

        pack_object
      end
    end
  end
end