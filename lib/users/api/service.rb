# frozen_string_literal: true

require "sinatra/base"
require "sinatra/namespace"
require "users/services"
require_relative "inputports"
require_relative "presenters"

module Users
  module API

    class Service < Sinatra::Base
      register Sinatra::Namespace
      include Users::Services
      include Users::API::InputPorts
      include Users::API::Presenters

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
          UsersPresenter.(
            SelectUsersPort.(SelectUsers, params),
            "/api/v1/users/?limit=%i&offset=%i"
          ).to_json
        rescue ArgumentError, Users::Error => e
          error 400, {error: e.message}.to_json
        end

        # /api/v1/users/session/create-user
        post "/session/register-user" do
          { "data" => UserPresenter.(JSONBodyPort.(RegisterUser, request.body)) }.to_json
        rescue ArgumentError, Users::Error => e
          error 400, {error: e.message}.to_json
        end

        # /api/v1/users/session/authenticate
        get "/session/authenticate" do
          { "data" => UserPresenter.(SymParamPort.(AuthenticateUser,                        params))
          }.to_json
        rescue ArgumentError, Users::Error => e
          error 400, {error: e.message}.to_json
        end

        # /api/v1/users/session/change_password
        post "/session/change-password" do
          { "data" => CredPresenter.(JSONBodyPort.(ChangeUserPassword, request.body)) }.to_json
        rescue ArgumentError, Users::Error => e
          error 400, {error: e.message}.to_json
        end

      end
    end

  end
end
