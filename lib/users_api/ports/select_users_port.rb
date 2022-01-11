require_relative 'service_port'

module UsersAPI
  module Ports

    class SelectUsersPort < ServicePort
      port SelectUsers

      def initialize(params, urltt)
        super(params)
        @urltt = urltt
      end

      def params
        @params[:limit] = @params[:limit].to_i if @params[:limit]
        @params[:offset] = @params[:offset].to_i if @params[:offset]
        @params
      end

      def decorate(response)
        coll, meta = response
        users = coll.map{|u| hash_from(u) }
        links = {}
        links["prev"] = @urltt % [meta[:limit], meta[:prev]] if meta[:prev]
        links["next"] = @urltt % [meta[:limit], meta[:next]] if meta[:next]
        { "links": links, "data": users }
      end
    end

  end
end
