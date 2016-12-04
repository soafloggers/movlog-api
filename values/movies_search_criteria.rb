# frozen_string_literal: true

# Input for SearchMovies
class MoviesSearchCriteria
  include WordMagic

  attr_accessor :terms

  def initialize(params)
    @terms = reasonable_search_terms(params[:search])
  end
end
