# frozen_string_literal: true
require_relative 'movie'

class MoviesRepresenter < Roar::Decorator
  include Roar::JSON

  collection :movies, extend: MovieRepresenter, class: Movie
end
