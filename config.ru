require 'rubygems'
require 'bundler'
require 'rack/handler/webrick'

Bundler.require

require 'users'
require './lib/users/api/service'
require './lib/users/gateways/memory_gateway'
require './lib/users/gateways/pstore_gateway'

# Users.gateway = Users::Gateways::MemoryGateway.new
Users.gateway = Users::Gateways::PStoreGateway.new
run Users::API::Service
