# frozen_string_literal: true

# MovlogAPI web service
class MovlogAPI < Sinatra::Base
  get "/#{API_VER}/:keyword/movie/?" do
    keyword = params[:keyword].gsub(/\+/, ' ')
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

  # Body args (JSON) e.g.: {"url": "http://www.omdbapi.com?t=star+wars&y=&plot=short&r=json"}
  post "/#{API_VER}/movie/?" do
    begin
      body_params = JSON.parse request.body.read
      omdb_url = body_params['url']
      ombd_movie = JSON.parse(HTTP.get(omdb_url).body)

      if Movie.find(imdb_id: ombd_movie['imdbID'])
        halt 422, "Movie (id: #{ombd_movie['imdbID']})already exists"
      end

      movlog_movie = Movlog::Movie.find(t: ombd_movie['Title'].gsub(/ /, '+'))
    rescue
      content_type 'text/plain'
      halt 400, "Movie (url: #{omdb_url}) could not be found"
    end

    begin
      movie = Movie.create(imdb_id: movlog_movie.imdb_id, title: movlog_movie.title,
                           actors: movlog_movie.actors, plot: movlog_movie.plot)
      locations = JSON.parse(movlog_movie.get_location)
      locations.each do |name|
        Location.create(
          movie_id:       movie.id,
          name:           name,
          airport:        'air'
        )
      end

      content_type 'application/json'
      { movie_id: movie.id, title: movie.title }.to_json
    rescue
      content_type 'text/plain'
      halt 500, "Cannot create movie (id: #{movlog_movie.imdb_id})"
    end
  end
end
