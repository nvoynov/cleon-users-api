require_relative '../../spec_helper'
include UsersAPI::Ports

describe ServicePort do

  class EchoService
    def self.call(*args, **kwargs)
      kwargs
    end
  end

  class SpecServicePort < ServicePort
    port EchoService
    def decorate(response)
      response
    end
  end

  describe '#call' do
    let(:port) { SpecServicePort }
    let(:user) { {name: 'user', email: 'e@c.c'} }

    it 'must call ported service' do
      response = port.(user)
      assert_instance_of Hash, response
      assert_equal user[:name], response[:name]
      assert_equal user[:email], response[:email]
    end
  end

  describe '#new' do
    it 'must accept hash' do
       SpecServicePort.new({})
    end

    it 'must raise ArgumentError for other arguments' do
      err = assert_raises(ArgumentError) { SpecServicePort.new(1) }
      assert_match %r{Hash}, err.message
    end
  end

  describe '#params' do
    let(:para) { {para: 1} }
    let(:port) { SpecServicePort.new(para) }

    it 'must return @params' do
      assert_equal para, port.params
    end
  end

  describe '#decorate' do
    class ServicePortStub < ServicePort
    end

    let(:para) { {para: 1} }
    let(:port) { ServicePortStub.new(para) }
    let(:user) { Users::Entities::User.new(name: 'user', email: 'e@c.c') }

    it 'must decorate entity' do
      response = port.decorate(user)
      assert_equal response["name"], user.name
      assert_equal response["email"], user.email
    end

    it 'must raise unless entity' do
      err = assert_raises(ArgumentError) { port.decorate(1) }
      assert_match %r{Override #decorate}, err.message
    end
  end
end
