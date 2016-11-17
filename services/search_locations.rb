# frozen_string_literal: true

# Loads data from Facebook group to database
class SearchLocations
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_params, lambda { |params|
    movie = Movie.find(title: keyword)
    if movie
      Right( movie: movie )
    else
      Left(Error.new(:not_found, 'Movie not found'))
    end
  }

  register :search_locations, lambda { |input|
    postings = MovieLocationsQuery.call(input[:movie])
    Right(results)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :search_locations
    end.call(params)
  end
end
