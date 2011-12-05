module Cryptosphere
  class Tree < Node
    def self.[](*entries)
      new(entries)
    end
    
    def initialize(entries)
      @entries = entries
    end
    
    def to_s
      @entries.sort_by { |e| e.name }.map(&:to_s).join("\n")
    end
    
    # Individual entries in a tree
    class Entry < Struct.new(:mode, :type, :id, :key, :name)
      def to_s
        "#{mode} #{type} #{id} #{key} #{name}"
      end
    end
  end
end