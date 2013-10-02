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
      TYPES = %w(commit tree blob tag).unshift(nil)

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
        @body   = nil
        @closed = false

        @inflater  = Zlib::Inflate.new
        @sha1      = Digest::SHA1.new
        @hexdigest = nil

        @sha1.update("#{TYPES[type]} #{length}\0")
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