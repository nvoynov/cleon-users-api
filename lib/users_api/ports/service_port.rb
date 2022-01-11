require 'users/services'
include Users::Services

module UsersAPI
  module Ports

    # Service port for the Users domain service
    # The main point that stands for the port - The HTTP/JSON client
    #   - does not understand domain entities, that should be translated
    #   - might require some additinal data to guide the client further
    class ServicePort

      class << self
        attr_reader :service

        def port(service)
          @service = service
        end

        def call(*args, **kwargs)
          new(*args, **kwargs).call
        end
      end

      # @param params [Hash]
      def initialize(params)
        raise ArgumentError.new(":params argument must be a Hash"
        ) unless params.is_a?(Hash)
        @params = params
      end

      def params
        @params
      end

      def call
        # decorate(service.(**params))
        decorate(do_call)
      end

      def do_call
        return service.() unless params
        service.(**params)
      end

      def decorate(response)
        raise ArgumentError.new(
          "Override #decorate(#{response.class.name}) in #{self.class.name}"
        ) unless entity?(response)
        hash_from(response)
      end

      def service
        self.class.service
      end

      def entity?(object)
        object.is_a?(Users::Entities::Entity)
      end

      def hash_from(object)
        {}.tap do |h|
          object.instance_variables.each do |v|
            key = "#{v.to_s.sub(/^@/, '')}"
            h[key] = object.instance_variable_get(v)
          end
        end
      end
    end

  end
end
