# frozen_string_literal: true

# Input for SearchMovies
class MoviesSearchCriteria
  include WordMagic

  attr_accessor :whole_term
  attr_accessor :terms

  def initialize(params)
    @terms = reasonable_search_terms(params[:search])
    @whole_term = reasonable_search_whole_term(params[:search])
  end

end
