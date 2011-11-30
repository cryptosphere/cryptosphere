require 'digest/sha2'
require 'openssl'
require 'tempfile'

module Cryptosphere
  class Node
    attr_reader :id, :key, :path
    
    class << self
      attr_reader :path
      
      # Configure the Cryptosphere Node store
      def setup(options = {})
        unless options[:root]
          raise ArgumentError, "no :root path given"
        end
        
        unless File.directory? options[:root]
          raise ArgumentError, "no such directory: #{options[:root]}"
        end
        
        @path = File.expand_path("nodes", options[:root])
        FileUtils.mkdir @path unless File.directory? @path
        
        nil
      end
    end
    
    def initialize(id, key)
      @id, @key = id, key
      @path = File.join(self.class.path, @id)
    end
    
    def decrypt
      raise "can't decrypt node without key" unless @key
      
      cipher = Cryptosphere.block_cipher
      cipher.decrypt
      cipher.key = [@key].pack("H*")
      cipher.iv = CONVERGENCE_NONSECRET
      
      output = ''
      
      File.open(@path, 'r') do |file|
        while data = file.read(4096)
          output << cipher.update(data)
        end
      end
        
      output << cipher.final
    end
  end
end