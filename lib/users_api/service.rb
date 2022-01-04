# frozen_string_literal: true

require "sinatra/base"
require "sinatra/namespace"
require_relative "version"
require_relative "ports"

module UsersAPI

  class Service < Sinatra::Base
    register Sinatra::Namespace
    include UsersAPI::Ports

    configure :production, :development do
      enable :logging
    end

    def self.base_url
      @base_url ||= "/api/v#{VERSION.split('.').first}/users"
    end

    def base_url
      self.class.base_url
    end

    namespace base_url do

      get('/session/register-user') { "Hello, World!" }

      # /api/v1/users/
      get "/" do
        SelectUsersPort.(params,
          "#{base_url}/?limit=%i&offset=%i"
        ).to_json
      rescue ArgumentError, Users::Error => e
        error 400, {error: e.message}.to_json
      end

      # /api/v1/users/session/create-user
      post "/session/register-user" do
        { "data" => RegisterUserPort.(request.body.string)
        }.to_json
      rescue ArgumentError, Users::Error => e
        error 400, {error: e.message}.to_json
      end

      # /api/v1/users/session/authenticate
      post "/session/authenticate" do
        { "data" => AuthenticateUserPort.(request.body.string)
        }.to_json
      rescue ArgumentError, Users::Error => e
        error 400, {error: e.message}.to_json
      end

      # /api/v1/users/session/change_password
      post "/session/change-password" do
        { "data" => ChangeUserPasswordPort.(request.body.string)
        }.to_json
      rescue ArgumentError, Users::Error => e
        error 400, {error: e.message}.to_json
      end

    end
  end

end
