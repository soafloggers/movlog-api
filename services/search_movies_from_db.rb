# frozen_string_literal: true

# Search data from database
class SearchMoviesFromDb
  extend Dry::Monads::Either::Mixin

  def self.call(search_term)
    movies = MoviesQuery.call(search_term.terms)
    results = MoviesSearchResults.new(
      search_term.terms, movies
    )
    Right(results)
  end
end
