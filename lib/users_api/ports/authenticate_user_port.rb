require_relative 'service_port'

module UsersAPI
  module Ports

    class AuthenticateUserPort < ServicePort
      port AuthenticateUser
    end

  end
end
