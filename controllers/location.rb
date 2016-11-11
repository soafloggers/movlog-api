# frozen_string_literal: true

# MovlogAPI web service
class MovlogAPI < Sinatra::Base
  get "/#{API_VER}/:keyword/location/?" do
    keyword = params[:keyword]
    begin
      movie = Movie.find(title: keyword)
      halt 400, "Movie (keyword: #{keyword}) not found" unless movie

      relevant_locations = movie.locations

      locations = {
        locations: relevant_locations.map do |loc|
          location = { id: loc.id, movie_id: movie.id }
          location[:name] = loc.name if loc.name
          location[:airport] = loc.airport if loc.airport
          { location: location }
        end
      }

      content_type 'application/json'
      locations.to_json
    rescue
      content_type 'text/plain'
      halt 404, "Cannot find movie (keyword: #{keyword}) locations"
    end
  end
end
