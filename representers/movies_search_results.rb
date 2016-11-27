# frozen_string_literal: true
require_relative 'movie'

class MoviesSearchResultsRepresenter < Roar::Decorator
  include Roar::JSON

  property :search_terms_used
  property :movies, extend: MovieRepresenter, class: Movie
end