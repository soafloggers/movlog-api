# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'vcr'
require 'webmock'

require './init.rb'

include Rack::Test::Methods

def app
  MovlogAPI
end

FIXTURES_FOLDER = 'spec/fixtures'
CASSETTES_FOLDER = "#{FIXTURES_FOLDER}/cassettes"
MOVIES_CASSETTE = 'movies'
LOCATIONS_CASSETTE = 'locations'
AIRPORT_CASSETTE = 'airport'


VCR.configure do |c|
  c.cassette_library_dir = CASSETTES_FOLDER
  c.hook_into :webmock

  c.filter_sensitive_data('<SKY_API_KEY>')  { ENV['SKY_API_KEY'] }
  c.filter_sensitive_data('<AIRBNB_CLIENT_ID>') { ENV['AIRBNB_CLIENT_ID'] }
end

HAPPY_MOVIE_URL = 'http://www.omdbapi.com?t=Star+Wars:+Episode+IV+-+A+New+Hope&y=&plot=short&r=json'
SAD_MOVIE_URL = 'http://www.omdbapi.com?t=sadmovie&y=&plot=short&r=json'

SAD_MOVIE = 'sadmovie'
SAD_LOCATION_ID = '0000'
REMOVED_LOCATION_ID = '0000'
