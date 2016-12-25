# frozen_string_literal: true

# search locations
class SearchMovieDetails
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_params, lambda { |params|
    keyword = params[:keyword].gsub(/\+/, ' ')
    movie = Movie.find(title: keyword)
    if movie
      Right(id: movie.id, title: keyword)
    else
      Left(Error.new(:not_found, 'Movie not found'))
    end
  }

  register :search_locations, lambda { |movie|
    locations = Location.where(movie_id: movie[:id]).all
    results = MovieDetailsSearchResults.new(
      movie, locations
    )
    if locations
      Right(results)
    else
      Left(Error.new(:not_found, 'Location not found'))
    end
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :search_locations
    end.call(params)
  end
end
