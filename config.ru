require 'rubygems'
require 'bundler'
require 'rack/handler/webrick'

Bundler.require

require 'users'
require './lib/users_api/service'
require './lib/users_api/gateway'
require './test/users_api/memory_gateway'

# Users.gateway = Users::Gateways::MemoryGateway.new
Users.gateway = UsersAPI::MemoryGateway.new
run UsersAPI::Service
