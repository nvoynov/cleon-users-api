require_relative "../spec_helper"
require_relative "shared_gateway_specs"
include UsersAPI

describe Gateway do

  include SharedSaveUser
  include SharedFindUser
  include SharedFindUserByEmail
  include SharedSelectUsers
  include SharedSaveCredentials
  include SharedFindCredentials

  let(:gateway) { Gateway.new }
end
