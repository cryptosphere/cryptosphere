require 'thor'

module Cryptosphere
  class CLI < Thor
    
    desc 'setup', 'Configure the Cryptosphere'
    def setup
      puts "Hi there!"
    end
  end
end