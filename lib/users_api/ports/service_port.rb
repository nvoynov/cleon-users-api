# frozen_string_literal: true

module UsersAPI
  module Ports

    # Abstract class for porting services to possible faces, like API or UI
    #
    # @example
    #   SomeServicePort < ServicePort
    #     def initialize(params)
    #       @params = params
    #     end
    #
    #     def ported_call
    #       # port parameters to the ported service interface
    #       params = @params
    #       @response = SomeService.call(params)
    #     end
    #
    #     def decorate
    #       # port the service response to the face interface
    #       @response
    #     end
    #   end
    class ServicePort

      def self.call(*args, **kwargs)
        new(*args, **kwargs).call
      end

      private_class_method :new

      def call
        ported_call
        decorate
      end

      protected

      def ported_call
        override_it!
      end

      def decorate
        override_it!
      end

      def override_it!
        raise '#ported_call must be overridden in subclasses'
      end

      def hash_from(object)
        {}.tap{|h|
          object.instance_variables.each{|v|
            key = "#{v.to_s.sub(/^@/, '')}"
            h[key] = object.instance_variable_get(v)
          }
        }
      end

    end

  end
end
