# frozen_string_literal: true

require_relative "../spec_helper"

describe Users::API do

  it 'must have a version number' do
    _(Users::API::VERSION).wont_be_nil
  end

end
