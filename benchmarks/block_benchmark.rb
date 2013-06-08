require 'benchmark/ips'
require 'cryptosphere/block'

EXAMPLE_PLAINTEXT = "A" * 1_048_576
EXAMPLE_BLOCK     = Cryptosphere::Block.encrypt(EXAMPLE_PLAINTEXT) 

Benchmark.ips do |b|
  b.report("encrypt") do
    Cryptosphere::Block.encrypt(EXAMPLE_PLAINTEXT)
  end

  b.report("decrypt") do
    Cryptosphere::Block.new(EXAMPLE_BLOCK.ciphertext, EXAMPLE_BLOCK.key)
  end
end