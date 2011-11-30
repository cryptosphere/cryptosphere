require 'fileutils'

module Cryptosphere
  class NodeBuilder
    def initialize
      @hash_cipher = Cryptosphere.hash_cipher
      @file = Tempfile.new 'cryptosphere'
    end
    
    def write(data)
      @hash_cipher << data
      @file << data
    end
    alias_method :<<, :write
    
    def finish
      secret_key = @hash_cipher.hexdigest
      
      block_cipher = Cryptosphere.block_cipher
      block_cipher.encrypt
      block_cipher.key = @hash_cipher.digest
      block_cipher.iv  = CONVERGENCE_NONSECRET
      
      @file.rewind
      output = Tempfile.new 'cryptosphere'
      
      begin
        hash_cipher = Cryptosphere.hash_cipher
        while plaintext = @file.read(4096)
          ciphertext = block_cipher.update(plaintext)
          output << ciphertext
          hash_cipher << ciphertext
        end
      
        ciphertext = block_cipher.final
        output << ciphertext
        hash_cipher << ciphertext
        output.close
        
        node_id = hash_cipher.hexdigest
        FileUtils.mv output.path, File.join(Node.path, node_id)
        
        Node.new(node_id, secret_key)
      rescue Exception
        output.close rescue nil
        output.unlink rescue nil
        
        raise
      end
    ensure
      @file.close rescue nil
      @file.unlink rescue nil
    end
  end
end