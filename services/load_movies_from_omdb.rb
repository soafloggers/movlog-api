# frozen_string_literal: true

# Loads data from Movie data to database
class LoadMoviesFromOMDB
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params)
    Dry.Transaction(container: self) do
      step :retrieve_omdb_movies_data
      step :filter_exists_movies
      step :retrieve_movie_details_and_locations
      step :create_movies_and_locations
    end.call(params)
  end

  register :retrieve_omdb_movies_data, lambda { |search_term|
    begin
      omdb_movies = Movlog::Movies.find(s: search_term)
      Right(movies: omdb_movies.movies, search_term: search_term)
    rescue
      Left(Error.new(:cannot_process, 'search_term could not be resolved'))
    end
  }

  register :filter_exists_movies, lambda { |data|
    begin
      filtered_movies = Array.new
      data[:movies].each do |movie|
        filtered_movies << movie unless Movie.find(title: movie.title)
      end
      data[:movies] = filtered_movies
      Right(data)
    rescue
      Left(Error.new(:cannot_process, 'check movie exist failed'))
    end
  }

  register :retrieve_movie_details_and_locations, lambda { |data|
    data[:movies] = data[:movies].map do |movie|
      movie.get_details
      movie
    end
    Right(data)
  }

  register :create_movies_and_locations, lambda { |data|
    begin
      data[:movies] = data[:movies].map do |movie|
        movie_model = write_movie(movie)
        movie.get_location.each do |loc_name|
          write_movie_location(movie_model, loc_name)
        end
        movie_model
      end
      results = MoviesSearchResults.new(
        data[:search_term], data[:movies]
      )
      Right(results)
    rescue
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

  # def self.write_location_airports(location, airports)
  #   airports.each do |airport|
  #     Airport.create(name: airport.name,
  #                    countryCode: airport.countryCode,
  #                    lat: airport.lat, lng: airport.lng)
  #   end
  # end
end
