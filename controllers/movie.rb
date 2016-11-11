# frozen_string_literal: true

# MovlogAPI web service
class MovlogAPI < Sinatra::Base
  get "/#{API_VER}/:keyword/movie/?" do
    keyword = params[:keyword]
    begin
      movie = Movie.find(title: keyword)

      content_type 'application/json'
      {
        imdb_id: movie.imdb_id,
        title: movie.title,
        actors: movie.actors,
        plot: movie.plot
      }.to_json
    rescue
      content_type 'text/plain'
      halt 404, "Movie (keyword: #{keyword}) not found"
    end
  end
end