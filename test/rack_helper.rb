require_relative "spec_helper"

ENV['RACK_ENV'] = 'test'
include Rack::Test::Methods

def app
  Users::API::Service
end
