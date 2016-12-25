# frozen_string_literal: true
require_relative 'movie'

class MoviesSearchResultsRepresenter < Roar::Decorator
  include Roar::JSON

  property :search_terms
  collection :movies, extend: MovieRepresenter, class: Movie
end
