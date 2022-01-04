require 'users/services'
require_relative 'basic_post_port'

module UsersAPI
  module Ports

    class ChangeUserPasswordPort < BasicPostPort
      port Users::Services::ChangeUserPassword
      def decorate
        { "email" => @response.email }
      end
    end

  end
end
