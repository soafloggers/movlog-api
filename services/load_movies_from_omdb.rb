# frozen_string_literal: true

# Loads data from Movie data to database
class LoadMoviesFromOMDB
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params, api_url: nil, channel: nil)
    sleep_until_client_starts
    request_info = {
      search_term: params,
      api_url: api_url,
      channel: channel
    }

    Dry.Transaction(container: self) do
      step :retrieve_omdb_movies_data
      step :filter_exists_movies
      step :retrieve_movie_details_and_locations
      step :create_movies_and_locations
    end.call(request_info)
  end

  register :retrieve_omdb_movies_data, lambda { |request_info|
    begin
      omdb_movies = Movlog::Movies.find(s: request_info[:search_term])
      request_info[:movies] = omdb_movies.movies
      publish(request_info, '35')
      Right(request_info)
    rescue
      publish(request_info, 'search_term could not be resolved')
      Left(Error.new(:cannot_process, 'search_term could not be resolved'))
    end
  }

  register :filter_exists_movies, lambda { |request_info|
    begin
      filtered_movies = Array.new
      request_info[:movies].each do |movie|
        filtered_movies << movie unless Movie.find(title: movie.title)
      end
      request_info[:movies] = filtered_movies
      publish(request_info, '50')
      Right(request_info)
    rescue
      publish(request_info, 'check movie exist failed')
      Left(Error.new(:cannot_process, 'check movie exist failed'))
    end
  }

  register :retrieve_movie_details_and_locations, lambda { |request_info|
    request_info[:movies] = request_info[:movies].map do |movie|
      movie.get_details
      movie
    end

    publish(request_info, '65')
    Right(request_info)
  }

  register :create_movies_and_locations, lambda { |request_info|
    begin
      request_info[:movies] = request_info[:movies].map do |movie|
        movie_model = write_movie(movie)
        movie.get_location.each do |loc_name|
          write_movie_location(movie_model, loc_name)
        end
        movie_model
      end
      results = MoviesSearchResults.new(
        request_info[:search_term], request_info[:movies]
      )

      publish(request_info, '100')
      Right(request_info)
    rescue
      publish(request_info, 'Movie not found')
      Left(Error.new(:not_found, 'Movie not found'))
    end
  }

  private_class_method

  def self.write_movie(movie)
    Movie.create(
      imdb_id: movie.imdb_id, title: movie.title, poster: movie.poster,
      plot: movie.plot, rating: movie.rating, awards: movie.awards,
      runtime: movie.runtime, year: movie.year, released: movie.released,
      director: movie.director, actors: movie.actors, genre: movie.genre
    )
  end

  def self.write_movie_location(movie, location)
    movie.add_location(name: location)
  end

  def self.publish(request_info, message)
    return unless request_info[:channel]
    HTTP.headers('Content-Type' => 'application/json').post(
      "#{request_info[:api_url]}/faye",
      json: {
        channel: "/#{request_info[:channel]}",
        data: message
      }
    )
  end

  def self.sleep_until_client_starts
    sleep(0.5)
  end
end
