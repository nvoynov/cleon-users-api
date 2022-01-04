require_relative '../../spec_helper'
require 'minitest/autorun'
include UsersAPI::Ports

describe ServicePort do

  class Entity
    attr_reader :name
    def initialize(name)
      @name = name
    end
  end

  class SpecService
    def self.call(*args, **kwargs)
      new(*args, **kwargs).call
    end

    def initialize(args)
      @args = args
    end

    # return entity by kwargs
    def call
      @args.map{|a| Entity.new(a)}
    end
  end

  class SpecServicePort < ServicePort

    public_class_method :new
    public :ported_call, :decorate

    def initialize(params)
      @params = params
    end

    def ported_call
      @response = SpecService.(@params)
    end

    def decorate
      @response.map{|e| hash_from(e)}
    end

  end

  describe Entity do
    it 'must create entity with name attr' do
      e = Entity.new('name')
      assert_instance_of Entity, e
      assert_respond_to e, :name
      assert_equal 'name', e.name
    end
  end

  describe SpecService do
    let(:names) { %w(foo bar apple banana) }
    it 'must retrn array of entities' do
      response = SpecService.(names)
      assert_instance_of Array, response
      assert_equal 4, response.size
      assert_instance_of Entity, response.first
    end
  end

  describe SpecServicePort do
    let(:arguments) { %w(foo bar apple banana) }
    let(:spec_class) { SpecServicePort }
    let(:spec_object) { SpecServicePort.new(arguments) }
    let(:response)  { arguments.map{|a| Entity.new(a)} }
    let(:decorated) { response.map{|e| {"name" => e.name}} }

    describe '#call' do
      it 'must retur decorated response' do
        assert_equal decorated, spec_class.(arguments)
      end
    end
  end
end
