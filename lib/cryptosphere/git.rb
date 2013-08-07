# Actual git dependencies listed below
require 'cryptosphere/git/pack_object'
require 'cryptosphere/git/pack_reader'
require 'cryptosphere/git/receive_pack'
require 'cryptosphere/git/refs'

# This is where the routes for the Git server are presently served from
# TODO: re-evaluate this. Possibly needs a separate origin?
require 'cryptosphere/app'