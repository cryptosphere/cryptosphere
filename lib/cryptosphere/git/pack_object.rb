require 'zlib'
require 'digest'

module Cryptosphere
  module Git
    # Pack objects represent data within Git. They are described in Git's
    # documentation under:
    #
    #     Documentation/technical/pack-format.txt
    #
    class PackObject
      TYPES = [nil, :commit, :tree, :blob, :tag]

      attr_reader :type_id, :length

      # Create a new streamable pack object
      #
      # @param [PackReader] reader object to get data from
      # @param [Fixnum] type_id of git pack object
      # @param [Fixnum] length of pack object
      #
      # @return [PackObject] a new PackObject ready to stream
      def initialize(reader, type_id, length)
        @reader  = reader
        @type_id = type_id
        @length  = length
        @body    = nil
        @closed  = false

        @inflater  = Zlib::Inflate.new
        @sha1      = Digest::SHA1.new
        @hexdigest = nil

        header = "#{type} #{length}\0"
        @sha1.update(header)
      end

      # Return the type of the PackObject as a symbol
      #
      # @return [Symbol] a symbol identifying the type of this object
      def type
        TYPES[@type_id]
      end

      # Read data from a PackObject
      #
      # @param [Fixnum] length to read (max)
      #
      # @return [String] uncompressed data from this object
      def readpartial(length = nil)
        raise StateError, "already closed" if @closed

        if @inflater.total_out == @length
          # Leftover data
          @reader.finish_object(@inflater.finish)
          @closed = true
          return
        end

        chunk = @reader.readpartial(length)
        data  = @inflater.inflate(chunk)
        @sha1.update(data)

        data
      end

      # Read the entirety of a PackObject as a String
      #
      # @return [String] body of this PackObject as a String
      def body
        @body ||= begin
          body = ""
          while chunk = readpartial
            body << chunk
          end
          body
        end
      end

      # Return the SHA1 digest for this object as a string
      #
      # @return [String] SHA1 digest for this object (if complete)
      def sha1_hexdigest
        @hexdigest ||= begin
          raise StateError, "not finished reading object" unless @closed
          @sha1.hexdigest
        end
      end
      alias id sha1_hexdigest
    end
  end
end