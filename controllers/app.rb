# frozen_string_literal: true

# MovlogAPI web service
class MovlogAPI < Sinatra::Base
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
