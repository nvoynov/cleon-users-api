require_relative "../spec_helper"
require_relative "gateway_specs"
include Users::Gateways

describe MemoryGateway do

  include SharedSaveUser
  include SharedFindUser
  include SharedFindUserByEmail
  include SharedSelectUsers
  include SharedSaveCredentials
  include SharedFindCredentials

  let(:gateway) { MemoryGateway.new }
end
