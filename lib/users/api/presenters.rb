# frozen_string_literal: true

require 'delegate'

module Users
  module API

    module Presenters

      class Presenter < SimpleDelegator
        def self.call(*args)
          new(*args).call
        end

        def call
        end
      end

      class UserPresenter < Presenter
        def call
          {
            "uuid" => self.uuid,
            "name" => self.name,
            "email" => self.email
          }
        end
      end

      class CredPresenter < Presenter
        def call
          { "email" => self.email }
        end
      end

      class UsersPresenter < SimpleDelegator

        def self.call(object, urltt)
          new(object, urltt).call
        end

        def initialize(object, urltt)
          super(object)
          @urltt = urltt
        end

        def call
          data, meta = self
          users = data.map{|u| {"uuid": u.uuid, "name": u.name, "email": u.email}}
          links = {}
          links["prev"] = @urltt % [meta[:limit], meta[:prev]] if meta[:prev]
          links["next"] = @urltt % [meta[:limit], meta[:next]] if meta[:next]
          { "links": links, "data": users }
        end
      end

    end
  end
end
