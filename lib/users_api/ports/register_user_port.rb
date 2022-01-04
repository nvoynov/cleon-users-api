require 'users/services'
require_relative 'basic_post_port'

module UsersAPI
  module Ports

    class RegisterUserPort < BasicPostPort
      port Users::Services::RegisterUser
    end

  end
end
