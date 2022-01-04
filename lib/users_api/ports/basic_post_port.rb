require_relative 'service_port'

module UsersAPI
  module Ports

    class BasicPostPort < ServicePort
      def self.port(service)
        @service = service
      end

      def self.ported
        @service
      end

      def ported
        self.class.ported
      end

      def initialize(params)
        @params = params
      end

      def ported_para
        JSON.parse(@params, {symbolize_names: true}).to_h
      end

      def ported_call
        @response = ported.(**ported_para)
      end

      def decorate
        hash_from(@response)
      end
    end

  end
end
