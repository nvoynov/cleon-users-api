# frozen_string_literal: true

require_relative "spec_helper"

describe UsersAPI do

  it 'must have a version number' do
    _(UsersAPI::VERSION).wont_be_nil
  end

end
