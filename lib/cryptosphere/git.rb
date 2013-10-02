require 'cryptosphere/git/pack_object'
require 'cryptosphere/git/pack_reader'

# Lattice resources for the Git server
require 'cryptosphere/git/resources/receive_pack'
require 'cryptosphere/git/resources/refs'

# This is where the routes for the Git server are presently served from
# TODO: re-evaluate this. Possibly needs a separate origin?
require 'cryptosphere/app'