# frozen_string_literal: true
require_relative 'spec_helper.rb'

describe 'Airport specifications' do
  before do
    VCR.insert_cassette AIRPORT_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Find airport by location' do
    before do
      DB[:movies].delete
      DB[:locations].delete
      # DB[:airports].delete
      post 'api/v0.1/movie',
           { url: HAPPY_MOVIE_URL }.to_json,
           'CONTENT_TYPE' => 'application/json'
    end

    it 'HAPPY: should find airports given a correct location' do
      location = Location.first.name.gsub(/ /, '+')
      get "api/v0.1/airport/#{location}"
      # print last_response.body.to_s
      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      airport_data = JSON.parse(last_response.body)
      airport_data['airports'].length.must_be :>=, 0
    end

    # it 'SAD: should report if a location is not found' do
    #   get "api/v0.1/movie/#{SAD_LOCATION_ID}"
    #
    #   last_response.status.must_equal 404
    #   # last_response.body.must_include SAD_MOVIE
    # end
  end

  # describe 'Loading and saving a new movie by movie name' do
  #   before do
  #     DB[:movies].delete
  #     DB[:locations].delete
  #     DB[:airport].delete
  #   end
  #
  #   it '(HAPPY) should load and save a new movie by its OMDB URL' do
  #     post 'api/v0.1/movie',
  #          { url: HAPPY_MOVIE_URL }.to_json,
  #          'CONTENT_TYPE' => 'application/json'
  #
  #     last_response.status.must_equal 200
  #     last_response.content_type.must_equal 'application/json'
  #     airport_data = JSON.parse(last_response.body)
  #     airport_data['airports'].length.must_be :>=, 0
  #
  #     Movie.count.must_equal 1
  #     Location.count.must_be :>=, 1
  #     Airport.count.must_be :>=, 1
  #   end
  #
  #   it '(BAD) should report error if given invalid URL' do
  #     post 'api/v0.1/movie',
  #          { url: SAD_MOVIE_URL }.to_json,
  #          'CONTENT_TYPE' => 'application/json'
  #
  #     last_response.status.must_equal 422
  #     last_response.body.must_include 'Airport data cannot get'
  #   end
  # end
end
