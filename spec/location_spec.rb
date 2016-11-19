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
      get "api/v0.1/#{title}/location"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      location_data = JSON.parse(last_response.body)
      location_data.wont_be_nil
    end

    it 'SAD: should report if the locations cannot be found' do
      get "api/v0.1/#{SAD_MOVIE}/location"

      last_response.status.must_equal 400
      last_response.body.must_include SAD_MOVIE
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

    # it '(HAPPY) should successfully update valid location' do
    #   original = Location.first
    #   put "api/v0.1/location/#{original.id}/aaa"
    #   last_response.status.must_equal 200
    #   updated = Location.first
    #   updated.airport.must_equal('aaa')
    # end
    #
    # it '(BAD) should report error if given invalid posting ID' do
    #   put "api/v0.1/location/#{SAD_LOCATION_ID}/bbb"
    #
    #   last_response.status.must_equal 400
    #   last_response.body.must_include SAD_LOCATION_ID
    # end
  end
end
