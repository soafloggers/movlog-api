# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Movie Routes' do
  before do
    VCR.insert_cassette GROUPS_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Find movie by keyword' do
    it 'HAPPY: should find a movie given a correct keyword' do
      get "api/v0.1/#{HAPPY_MOVIE}/movie"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      movie_data = JSON.parse(last_response.body)
      movie_data['title'].length.must_be :>, 0
      movie_data['response'].must_equal 'True'
    end

    it 'SAD: should report if a movie is not found' do
      get "api/v0.1/#{SAD_MOVIE}/movie"
      
      last_response.status.must_equal 200
      movie_data = JSON.parse(last_response.body)
      movie_data['response'].must_equal 'False'
    end
  end
end
