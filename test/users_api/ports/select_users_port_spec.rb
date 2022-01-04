require_relative '../../spec_helper'
require 'minitest/autorun'
include UsersAPI::Ports
include Users::Entities

describe SelectUsersPort do

  class SpecPort < SelectUsersPort
    public_class_method :new
    def stub_response(response)
      @response = response
    end
  end

  let(:coll) {[
      User.new(name: 'first',  email: 'a@c.c'),
      User.new(name: 'second', email: 'b@c.c'),
      User.new(name: 'third',  email: 'c@c.c')
    ]}
  let(:meta) { {query: '', order_by: '', limit: 20, next: 2, prev: 0} }
  let(:port) {
    SpecPort.new(nil, "/api/v1/users/?limit=%i&offset=%i").tap{|port|
      port.stub_response([coll, meta])
    }
  }

  describe '#decorate' do
    it 'must return hash of users and links' do
      decorated = port.decorate
      assert decorated[:links]
      assert decorated[:data]
      assert_instance_of Array, decorated[:data]
    end
  end
end
