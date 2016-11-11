# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Movie Routes' do
  before do
    VCR.insert_cassette MOVIES_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Find movie by keyword' do
    before do
      # TODO: find a better way
      DB[:movies].delete
      DB[:locations].delete
      post 'api/v0.1/movie',
           { url: HAPPY_MOVIE_URL }.to_json,
           'CONTENT_TYPE' => 'application/json'
    end

    it 'HAPPY: should find a movie given a correct keyword' do
      get "api/v0.1/#{Movie.first.imdb_id}/movie"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      movie_data = JSON.parse(last_response.body)
      movie_data['response'].must_equal 'True'
    end

    it 'SAD: should report if a movie is not found' do
      get "api/v0.1/#{SAD_MOVIE}/movie"

      last_response.content_type.must_equal 'application/json'
      movie_data = JSON.parse(last_response.body)
      movie_data['response'].must_equal 'False'
    end
  end

  describe 'Loading and saving a new movie by movie name' do
    before do
      DB[:movies].delete
      DB[:locations].delete
    end

    it '(HAPPY) should load and save a new movie by its OMDB URL' do
      post 'api/v0.1/movie',
           { url: HAPPY_MOVIE_URL }.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      movie_data = JSON.parse(last_response.body)
      movie_data['response'].must_equal 'True'

      Movie.count.must_equal 1
      Location.count.must_be :>=, 10
    end

    it '(BAD) should report error if given invalid URL' do
      post 'api/v0.1/movie',
           { url: SAD_MOVIE_URL }.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.content_type.must_equal 'application/json'
      movie_data = JSON.parse(last_response.body)
      movie_data['response'].must_equal 'False'
    end

    it 'should report error if movie already exists' do
      2.times do
        post 'api/v0.1/movie',
             { url: HAPPY_MOVIE_URL }.to_json,
             'CONTENT_TYPE' => 'application/json'
      end

      last_response.status.must_equal 422
    end
  end
end
