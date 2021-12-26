require_relative '../spec_helper'
require 'users'
require 'json'
include Users::API::InputPorts

describe InputPort do
  it 'must check args' do
    err = assert_raises(ArgumentError) { InputPort.(String) }
    assert_match(/Users::Services::Service/, err.message)
    assert_match %r{Users::Services::Service}, err.message
  end
end
