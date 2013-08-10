module Cryptosphere
  module Git
    # Pack objects represent data within Git. They are described in Git's
    # documentation under:
    #
    #     Documentation/technical/pack-format.txt
    #
    class PackObject
      attr_reader :type, :length

      # Create a new streamable pack object
      #
      # @param [PackReader] reader object to get data from
      # @param [Fixnum] type of git pack object
      # @param [Fixnum] length of pack object
      #
      # @return [PackObject] a new PackObject ready to stream
      def initialize(reader, type, length)
        @reader = reader
        @type   = type
        @length = length
      end
    end
  end
end