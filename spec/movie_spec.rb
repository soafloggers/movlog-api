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

    # 10.times do
      it '(HAPPY) should find valid keyword movies' do
        magic_word = SpecSearch.random_title_word
        get "api/v0.1/movie?search=#{magic_word[:word]}"
        puts magic_word[:word]
        last_response.status.must_equal 200
        results = JSON.parse(last_response.body)
        results['search_terms_used'].count.must_equal 1
        # results['movies'].count.must_equal magic_word[:title_count]
      end
    # end

    # 5.times do
      it '(HAPPY) should find valid keyword combination movies' do
        magic_words = Array.new(3) { SpecSearch.random_title_word }
        keywords = magic_words.map { |magic| magic[:word] }.join('+')
        largest_count = magic_words.map { |magic| magic[:messages_count] }.max

        get "api/v0.1/movie?search=#{keywords}"
        last_response.status.must_equal 200
        results = JSON.parse(last_response.body)
        results['search_terms_used'].count.must_equal magic_words.count
        # results['movies'].count.must_be :>=, largest_count
      end
    # end

    # it 'HAPPY: should find a movie given a correct keyword' do
    #   title = Movie.first.title.gsub(/ /, '+')
    #   get "api/v0.1/movie/#{title}"
    #   # print last_response.body.to_s
    #   last_response.status.must_equal 200
    #   last_response.content_type.must_equal 'application/json'
    #   movie_data = JSON.parse(last_response.body)
    #   movie_data['title'].length.must_be :>=, 0
    # end

    # it 'SAD: should report if a movie is not found' do
    #   get "api/v0.1/movie/#{SAD_MOVIE}"

    #   last_response.status.must_equal 404
    #   last_response.body.must_include SAD_MOVIE
    # end
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
      movie_data['title'].length.must_be :>=, 0

      Movie.count.must_equal 1
      Location.count.must_be :>=, 1
    end

    it '(BAD) should report error if given invalid URL' do
      post 'api/v0.1/movie',
           { url: SAD_MOVIE_URL }.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 422
      last_response.body.must_include 'Movie data cannot parse title'
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
