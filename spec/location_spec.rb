# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Location Routes' do
  before do
    VCR.insert_cassette LOCATIONS_CASSETTE, record: :new_episodes

    # TODO: find a better way to populate !
    DB[:movies].delete
    DB[:locations].delete
    post 'api/v0.1/movie',
         { url: HAPPY_MOVIE_URL }.to_json,
         'CONTENT_TYPE' => 'application/json'
  end

  after do
    VCR.eject_cassette
  end

  describe 'Get the filming locations from a movie' do
    it 'HAPPY: should find the filming locations from a movie' do
      title = Movie.first.title.gsub(/ /, '+')
      get "api/v0.1/location/#{title}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      location_data = JSON.parse(last_response.body)
      location_data['locations'].count.must_be :>, 0
    end

    it 'SAD: should report if the locations cannot be found' do
      get "api/v0.1/location/#{SAD_MOVIE}"

      last_response.status.must_equal 404
      last_response.body.must_include 'Movie not found'
    end
  end

  describe 'Request to update a location' do
    after do
      DB[:movies].delete
      DB[:locations].delete
      post 'api/v0.1/movie',
           { url: HAPPY_MOVIE_URL }.to_json,
           'CONTENT_TYPE' => 'application/json'
    end

    it '(HAPPY) should successfully update valid location' do
      original = Location.first
      movie = Movie.first.title.gsub(/ /, '+')
      put "api/v0.1/location/#{original.id}/#{movie}"

      last_response.status.must_equal 200
      updated = Location.first
      updated.movie_id.must_equal(Movie.first.id)
    end

    it '(BAD) should report error if given invalid location ID' do
      put "api/v0.1/location/#{SAD_LOCATION_ID}/bbb"

      last_response.status.must_equal 400
      last_response.body.must_include 'Location is not stored'
    end
  end

  describe 'Request to get rooms info of a location' do
    it '(HAPPY) should successfully get rooms of a location' do
      get "api/v0.1/room/#{HAPPY_LOCATION}"

      rooms = JSON.parse(last_response.body.to_s)
      rooms.length.must_be :>, 0
      last_response.status.must_equal 200
    end
  end
end
