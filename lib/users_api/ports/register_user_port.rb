require_relative 'service_port'

module UsersAPI
  module Ports

    # Service port for the Users domain service
    class RegisterUserPort < ServicePort
      port RegisterUser
    end

  end
end
