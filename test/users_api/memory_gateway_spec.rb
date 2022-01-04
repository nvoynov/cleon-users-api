require_relative "../spec_helper"
require_relative "memory_gateway"
require_relative "shared_gateway_specs"
include UsersAPI

describe MemoryGateway do

  include SharedSaveUser
  include SharedFindUser
  include SharedFindUserByEmail
  include SharedSelectUsers
  include SharedSaveCredentials
  include SharedFindCredentials

  let(:gateway) { MemoryGateway.new }
end
