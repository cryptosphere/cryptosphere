require "rake/clean"
require "rbnacl/rake_tasks"

file "lib/libsodium.so" => :build_libsodium do
  cp $LIBSODIUM_PATH, "lib/libsodium.so"
end

task "ci:sodium" => "lib/libsodium.so"

task :ci => %w(ci:sodium spec)

CLEAN.add "lib/libsodium.*"
