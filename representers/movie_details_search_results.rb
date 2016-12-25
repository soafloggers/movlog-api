# frozen_string_literal: true
require_relative 'location'

# Represents overall group information for JSON API output
class MovieDetailsSearchResultsRepresenter < Roar::Decorator
  include Roar::JSON

  property :movie
  collection :locations, extend: LocationRepresenter, class: Location
end
