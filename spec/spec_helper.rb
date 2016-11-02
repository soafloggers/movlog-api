# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'vcr'
require 'webmock'

require_relative '../app'

include Rack::Test::Methods

def app
  MovlogAPI
end

FIXTURES_FOLDER = 'spec/fixtures'
CASSETTES_FOLDER = "#{FIXTURES_FOLDER}/cassettes"
GROUPS_CASSETTE = 'groups'

VCR.configure do |c|
  c.cassette_library_dir = CASSETTES_FOLDER
  c.hook_into :webmock

  c.filter_sensitive_data('<SKY_API_KEY>')  { ENV['SKY_API_KEY'] }
  c.filter_sensitive_data('<AIRBNB_CLIENT_ID>') { ENV['AIRBNB_CLIENT_ID'] }
end

HAPPY_MOVIE = 'Star+Wars'
SAD_MOVIE = 'Movie+Not+Found'
