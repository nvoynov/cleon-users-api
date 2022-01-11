require_relative 'service_port'

module UsersAPI
  module Ports

    class ChangeUserPasswordPort < ServicePort
      port ChangeUserPassword

      def decorate(response)
        { "email" => response.email }
      end
    end

  end
end
