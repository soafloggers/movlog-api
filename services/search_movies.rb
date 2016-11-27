# frozen_string_literal: true

# Loads data from OMDB to database
class SearchMovies
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_params, lambda { |params|
    search = MoviesSearchCriteria.new(params)
    if search
      Right(search: search)
    else
      Left(Error.new(:cannot_process, 'Please enter movie title'))
    end
  }

  register :search_movies, lambda { |input|
    movies = MoviesQuery.call(input[:search].terms)
    results = MoviesSearchResults.new(
      input[:search].terms, movies
    )
    Right(results)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :search_movies
    end.call(params)
  end
end
