require 'users/services'
require_relative 'basic_post_port'

module UsersAPI
  module Ports

    class AuthenticateUserPort < BasicPostPort
      port Users::Services::AuthenticateUser
    end

  end
end
