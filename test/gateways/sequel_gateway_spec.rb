require_relative "../spec_helper"
require_relative "gateway_specs"
include Users::Gateways

describe SequelGateway do

  include SharedSaveUser
  include SharedFindUser
  include SharedFindUserByEmail
  include SharedSelectUsers
  include SharedSaveCredentials
  include SharedFindCredentials

  let(:gateway) { SequelGateway.new }
end
