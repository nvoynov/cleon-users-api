require_relative 'service_port'

module UsersAPI
  module Ports

    class SelectUsersPort < ServicePort
      def initialize(params, urltt)
        @params = params
        @urltt = urltt
      end

      def ported_call
        limit = @params["limit"] ? @params["limit"].to_i : 25
        offset = @params["offset"] ? @params["offset"].to_i : 0
        @response = Users::Services::SelectUsers.(limit: limit, offset: offset)
      end

      def decorate
        coll, meta = @response
        users = coll.map{|u| hash_from(u) }
        links = {}
        links["prev"] = @urltt % [meta[:limit], meta[:prev]] if meta[:prev]
        links["next"] = @urltt % [meta[:limit], meta[:next]] if meta[:next]
        { "links": links, "data": users }
      end
    end

  end
end
