# frozen_string_literal: true
require 'sinatra'
require 'econfig'
require 'movlog'

# MovlogAPI web service
class MovlogAPI < Sinatra::Base
  extend Econfig::Shortcut

  Econfig.env = settings.environment.to_s
  Econfig.root = settings.root
  Skyscanner::SkyscannerApi.config.update(api_key: config.SKY_API_KEY)
  Airbnb::AirbnbApi.config.update(client_id: config.AIRBNB_CLIENT_ID)

  API_VER = 'api/v0.1'

  get '/?' do
    "MovlogAPI latest version endpoints are at: /#{API_VER}/"
  end

  get "/#{API_VER}/:keyword/movie/?" do
    keyword = params[:keyword]
    begin
      movie = Movlog::Movie.find(t: keyword)

      content_type 'application/json'
      {
        title: movie.title,
        actors: movie.actors,
        plot: movie.plot,
        response: movie.response,
      }.to_json
    rescue
      halt 404, "Movie (keyword: #{keyword}) not found"
    end
  end

  get "/#{API_VER}/:keyword/location/?" do
    keyword = params[:keyword]
    begin
      movie = Movlog::Movie.find(t: keyword)

      content_type 'application/json'
      { location: movie.get_location }.to_json
    rescue
      halt 404, "Cannot find movie (keyword: #{keyword}) locations"
    end
  end
end
