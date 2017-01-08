# frozen_string_literal: true
require_relative 'movie'
require_relative 'location'

# Represents overall group information for JSON API output
class MovieDetailsSearchResultsRepresenter < Roar::Decorator
  include Roar::JSON

  property :movie, extend: MovieRepresenter, class: Movie
  collection :locations, extend: LocationRepresenter, class: Location
end
