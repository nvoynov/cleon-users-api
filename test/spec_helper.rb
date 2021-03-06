# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require 'users_api'
require 'rack/test'
require 'minitest/pride'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! if ENV['MINITEST_REPORTER']
