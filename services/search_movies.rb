# frozen_string_literal: true

# Gets movie details from APIs
class SearchMovies
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :search_movies_from_db
      step :load_movies_from_omdb
      step :return_search_result
    end.call(params)
  end

  register :validate_params, lambda { |params|
    search_term = MoviesSearchCriteria.new(params)
    if search_term
      Right(search_term)
    else
      Left(Error.new(:cannot_process, 'Please enter movie title'))
    end
  }

  register :search_movies_from_db, lambda { |search_term|
    results = SearchMoviesFromDb.call(search_term)
    Right(search_term: search_term, db_results: results)
  }

  register :load_movies_from_omdb, lambda { |search_data|
    if !search_data[:db_results].success? ||
        search_data[:db_results].value.movies&.count.zero?
      results = LoadMoviesFromOMDB.call(search_data[:search_term].whole_term)
    else
      results = search_data[:db_results]
    end
    Right(results)
  }

  register :return_search_result, lambda { |results|
    if results.success?
      Right(results.value)
    else
      Left(Error.new('Movie not found!'))
    end
  }
end
