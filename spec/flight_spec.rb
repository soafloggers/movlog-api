# frozen_string_literal: true
require_relative 'spec_helper.rb'

describe 'Airport specifications' do
  before do
    VCR.insert_cassette AIRPORT_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Find flights by location' do
    before do
      DB[:movies].delete
      DB[:locations].delete
      post 'api/v0.1/movie',
           { search: HAPPY_MOVIE }.to_json,
           'CONTENT_TYPE' => 'application/json'
    end

    it 'HAPPY: should find flights given a correct location' do
      get "api/v0.1/flights/Taiwan/#{HAPPY_LOCATION}/anytime"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      flight_data = JSON.parse(last_response.body)
      puts last_response.body.to_s
      flight_data.length.must_be :>=, 0
    end

    it 'SAD: should report if a location is not found' do
      get "api/v0.1/flights/Taiwan/#{SAD_LOCATION}/anytime"

      last_response.status.must_equal 404
      # last_response.body.must_include SAD_MOVIE
    end
  end
end
