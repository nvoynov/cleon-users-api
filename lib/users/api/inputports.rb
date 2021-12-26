# frozen_string_literal: true

require "json"
require "users/argchkr"

module Users
  module API

    module InputPorts

      ServiceChkr = Users::ArgChkr::Policy.new(
        "serivce", ":%s must be Users::Services::Service",
        ->(v) { v < Users::Services::Service })

      # InputPort for service parameters
      #
      # @example from route handler that provides params
      #   ServieInputPort.(Service, params)
      #
      # @example when you have presenters
      #   Presenter.(ServiceInputPort.(Service, params))
      class InputPort
        def self.call(service, params = nil)
          ServiceChkr.chk!(service)
          new(service, params).call
        end

        def initialize(service, params)
          @service = service
          @params = params
        end

        def call
          @service.(**port_params)
        end

        # Transform input params to service
        # must be implemented in subclasses
        # @retrun [Hash] service params translated form orignal input
        # hint: transform_keys(&:to_sym)
        def port_params
        end
      end

      class SymParamPort < InputPort
        def port_params
          # @params.transform_keys(&:to_sym).to_h
          @params.map{|k,v| [k.to_sym, v]}.to_h          
        end
      end

      class JSONBodyPort < InputPort
        StringIOChkr = Users::ArgChkr::Policy.new(
          "params", ":%s must be StringIO",
          ->(v) { v.is_a? StringIO })

        def initialize(service, params)
          super(service, params)
          StringIOChkr.chk!(params)
          @params = params.string
        end

        def port_params
          JSON.parse(@params, {symbolize_names: true}).to_h
        end
      end

      class SelectUsersPort < InputPort
        def port_params
          @params["limit"]  ||= "25"
          @params["offset"] ||= "0"
          {
            limit:  @params["limit"].to_i,
            offset: @params["offset"].to_i
          }
        end
      end

    end
  end
end
